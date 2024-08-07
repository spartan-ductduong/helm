{{ define "spartan.cronjob" }}
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ include "spartan.fullname" $ }}-{{ .cronjob.name }}
  labels:
  {{- include "spartan.labels" $ | nindent 4 }}
spec:
  schedule: {{- default "0 * * * *" .cronjob.schedule | quote }}
  successfulJobsHistoryLimit: {{ default "3" .cronjob.successfulJobsHistoryLimit }}
  failedJobsHistoryLimit: {{ default "3" .cronjob.failedJobsHistoryLimit }}
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: {{ default "Never" .cronjob.restartPolicy }}
          containers:
          - name: {{ include "spartan.containerName" . }}
            command:
              - {{ default "/bin/sh" .cronjob.shell }}
              - -c
              - |
              {{- if .Values.datadog.enabled }}
                trap 'sleep 10 && pkill agent' EXIT
                set -o pipefail
                if [ ! `which curl` ]; then sleep 300; else while ! curl -Ns localhost:8126; do sleep 1 && echo "Waiting for datadog agent to start..."; done; fi
              {{- end }}
              {{- range .cronjob.commands }}
                {{ . }}
              {{- end }}
            securityContext:
              {{- toYaml .Values.securityContext | nindent 14 }}
            {{- if .cronjob.customImage.enabled }}
            image: {{ .cronjob.customImage.image }}
            {{- else }}
            image: "{{ .cronjob.image.repository }}:{{ .cronjob.image.tag | default "latest" }}"
            {{- end }}
            imagePullPolicy: {{ default "IfNotPresent" .cronjob.image.pullPolicy }}
            resources:
              {{- toYaml .cronjob.resources | nindent 14 }}
            envFrom:
              {{- if .Values.secret.asEnv.enabled }}
              - secretRef:
                  name: {{ include "spartan.secretAsEnv" $ }}
              {{- end }}
              {{- if .Values.secret.externalSecretEnv.enabled }}
              - secretRef:
                  name: {{ .Values.secret.externalSecretEnv.name }}
              {{- end }}
              {{- if .Values.configMap.asEnv.enabled }}
              - configMapRef:
                  name: {{ include "spartan.configMapAsEnv" $ }}
              {{- end }}
              {{- if .Values.configMap.externalConfigMapEnv.enabled }}
              - configMapRef:
                  name: {{ .Values.configMap.externalConfigMapEnv.name }}
              {{- end }}
            env:
            {{- if .Values.datadog.enabled }}
              - name: DD_KUBERNETES_KUBELET_NODENAME
                valueFrom:
                  fieldRef:
                    apiVersion: v1
                    fieldPath: spec.nodeName
              - name: DD_LOGS_ENABLED
                value: "true"
              - name: DD_LOGS_INJECTION
                value: "true"
              - name: DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL
                value: "true"
              - name: DD_ORCHESTRATOR_EXPLORER_ENABLED
                value: "true"
              - name: DD_PROCESS_AGENT_ENABLED
                value: "true"
              - name: DD_CLUSTER_AGENT_ENABLED
                value: "true"
            {{- end }}
            {{- if .Values.extraEnvs -}}
            {{ toYaml .Values.extraEnvs | nindent 14 }}
            {{- end }}
            volumeMounts:
            {{- if .Values.secret.asFile.enabled }}
              - name: {{ include "spartan.secretAsFile" $ }}
                readOnly: true
                mountPath: {{ .Values.secret.asFile.mountPath | quote }}
            {{- end }}
            {{- if .Values.secret.externalSecretFile.enabled }}
              - name: {{ .Values.secret.externalSecretFile.name }}
                readOnly: true
                mountPath: {{ .Values.secret.externalSecretFile.mountPath | quote }}
            {{- end }}
            {{- if .Values.configMap.asFile.enabled }}
              - name: {{ include "spartan.configMapAsFile" $ }}
                readOnly: true
                mountPath: {{ .Values.configMap.asFile.mountPath | quote }}
            {{- end }}
            {{- if .Values.configMap.externalConfigMapFile.enabled }}
              - name: {{ .Values.configMap.externalConfigMapFile.name }}
                readOnly: true
                mountPath: {{ .Values.configMap.externalConfigMapFile.mountPath | quote }}
            {{- end }}
            {{- range .Values.sidecars }}
            {{- if .sharedVolume }}
              - name: sidecar-volume
                readOnly: false
                mountPath: {{ .sharedVolume.mountPath }}
                subPath: {{ .name }}
            {{- end }}
            {{- end }}
{{- end }}
