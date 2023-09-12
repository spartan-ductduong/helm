{{ define "chargefuze.worker" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "chargefuze.fullname" $ }}-{{ .worker.name}}
  labels:
    {{- include "chargefuze.labels" $ | nindent 4 }}
    tier: "worker"
spec:
  replicas: {{ .worker.replicaCount | default 1 }}
  selector:
    matchLabels:
      {{- include "chargefuze.selectorLabels" $ | nindent 6 }}
  template:
    metadata:
      {{- if .worker.podAnnotations }}
      {{- with .worker.podAnnotations }}
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
        {{- include "chargefuze.selectorLabels" $ | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "chargefuze.serviceAccountName" $ }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      terminationGracePeriodSeconds: {{ .worker.terminationGracePeriodSeconds | default 180 }}
      containers:
        - name: {{ .Chart.Name }}
          command:
            - /bin/sh
            - -c
            - {{ .worker.command }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default "latest" }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          resources:
            {{- toYaml .worker.resources | nindent 12 }}
          envFrom:
            {{- if .Values.secret.asEnv.enabled }}
            - secretRef:
                name: {{ include "chargefuze.secretAsEnv" $ }}
            {{- end }}
            {{- if .Values.configMap.asEnv.enabled }}
            - configMapRef:
                name: {{ include "chargefuze.configMapAsEnv" $ }}
            {{- end }}
          volumeMounts:
          {{- if .Values.secret.asFile.enabled }}
            - name: {{ include "chargefuze.secretAsFile" $ }}
              readOnly: true
              mountPath: {{ .Values.secret.asFile.mountPath | quote }}
          {{- end }}
          {{- if .Values.configMap.asFile.enabled }}
            - name: {{ include "chargefuze.configMapAsFile" $ }}
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
        - name: {{ include "chargefuze.secretAsFile" $ }}
          secret:
            secretName: {{ include "chargefuze.secretAsFile" $ }}
      {{- end }}
      {{- if .Values.configMap.asFile.enabled }}
        - name: {{ include "chargefuze.configMapAsFile" $ }}
          secret:
            secretName: {{ include "chargefuze.configMapAsFile" $ }}
      {{- end }}
{{ end }}
