{{ define "chargefuze.hook" }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "chargefuze.fullname" $ }}-hook-{{ .hook.name}}
  labels:
    {{- include "chargefuze.labels" . | nindent 4 }}
    tier: "hook"
  annotations:
    "helm.sh/hook": "post-install,pre-upgrade"
    "helm.sh/hook-weight": "{{ .hook.hookWeight | default "0" }}"
    "helm.sh/resource-policy": keep
spec:
  backoffLimit: {{ .hook.backoffLimit | default 0 }}
  template:
    metadata:
      {{- if .hook.podAnnotations }}
      {{- with .hook.podAnnotations }}
      annotations:
          {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- else }}
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- end }}
      labels:
          {{- include "chargefuze.selectorLabels" . | nindent 8 }}
    spec:
        {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
          {{- toYaml . | nindent 8 }}
        {{- end }}
      serviceAccountName: {{ include "chargefuze.serviceAccountName" . }}
      securityContext:
          {{- toYaml .Values.podSecurityContext | nindent 8 }}
      restartPolicy: {{ .hook.restartPolicy | default "Never" }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
              {{- toYaml .Values.securityContext | nindent 12 }}
          {{- if .hook.customImage.enabled }}
          image: {{ .hook.customImage.image }}
          {{- else }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default "latest" }}"
          {{- end }}
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          command:
            - /bin/sh
            - -c
            - |
            {{- range .hook.commands }}
              {{ . }}
            {{- end }}
          resources:
              {{- toYaml .hook.resources | nindent 12 }}
          envFrom:
              {{- if .Values.secret.asEnv.enabled }}
            - secretRef:
                name: {{ include "chargefuze.secretAsEnv" . }}
              {{- end }}
              {{- if .Values.configMap.asEnv.enabled }}
            - configMapRef:
                name: {{ include "chargefuze.configMapAsEnv" . }}
              {{- end }}
          volumeMounts:
            {{- if .Values.secret.asFile.enabled }}
            - name: {{ include "chargefuze.secretAsFile" . }}
              readOnly: true
              mountPath: {{ .Values.secret.asFile.mountPath | quote }}
            {{- end }}
            {{- if .Values.configMap.asFile.enabled }}
            - name: {{ include "chargefuze.configMapAsFile" . }}
              readOnly: true
              mountPath: {{ .Values.configMap.asFile.mountPath | quote }}
            {{- end }}
        {{- with .Values.nodeSelector }}
      nodeSelector:
          {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with .Values.affinity }}
      affinity:
          {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with .Values.tolerations }}
      tolerations:
          {{- toYaml . | nindent 8 }}
        {{- end }}
      volumes:
        {{- if .Values.secret.asFile.enabled }}
        - name: {{ include "chargefuze.secretAsFile" . }}
          secret:
            secretName: {{ include "chargefuze.secretAsFile" . }}
        {{- end }}
        {{- if .Values.configMap.asFile.enabled }}
        - name: {{ include "chargefuze.configMapAsFile" . }}
          secret:
            secretName: {{ include "chargefuze.configMapAsFile" . }}
        {{- end }}
{{- end }}
