{{/*
This template serves as the blueprint for the DaemonSet objects that are created
within the common library.
*/}}
{{- define "bjw-s.common.class.daemonset" -}}
  {{- $labels := (merge (.Values.controller.labels | default dict) (include "common.labels" $ | fromYaml)) -}}
  {{- $annotations := (merge (.Values.controller.annotations | default dict) (include "common.annotations" $ | fromYaml)) -}}
---
apiVersion: apps/v1
kind: DaemonSet
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
{{- end }}
