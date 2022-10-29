{{/*
This template serves as a blueprint for Deployment objects that are created
using the common library.
*/}}
{{- define "bjw-s.common.class.deployment" -}}
  {{- $labels := (merge (.Values.controller.labels | default dict) (include "common.labels" $ | fromYaml)) -}}
  {{- $annotations := (merge (.Values.controller.annotations | default dict) (include "common.annotations" $ | fromYaml)) -}}
  {{- $strategy := default "Recreate" .Values.controller.strategy -}}
  {{- if and (ne $strategy "Recreate") (ne $strategy "RollingUpdate") -}}
    {{- fail (printf "Not a valid strategy type for Deployment (%s)" $strategy) -}}
  {{- end -}}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "bjw-s.common.lib.chart.names.fullname" . }}
  {{- with $labels }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $annotations }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  revisionHistoryLimit: {{ .Values.controller.revisionHistoryLimit }}
  replicas: {{ .Values.controller.replicas }}
  strategy:
    type: {{ $strategy }}
    {{- with .Values.controller.rollingUpdate }}
      {{- if and (eq $strategy "RollingUpdate") (or .surge .unavailable) }}
    rollingUpdate:
        {{- with .unavailable }}
      maxUnavailable: {{ . }}
        {{- end }}
        {{- with .surge }}
      maxSurge: {{ . }}
        {{- end }}
      {{- end }}
    {{- end }}
  selector:
    matchLabels:
      {{- include "common.labels.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with include ("common.podAnnotations") . }}
      annotations:
        {{- . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "common.labels.selectorLabels" . | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- include "bjw-s.common.lib.controller.pod" . | nindent 6 }}
{{- end -}}
