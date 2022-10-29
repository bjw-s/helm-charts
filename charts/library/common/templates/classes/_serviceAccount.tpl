{{/*
This template serves as a blueprint for ServiceAccount objects that are created
using the common library.
*/}}
{{- define "bjw-s.common.class.serviceAccount" -}}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "bjw-s.common.lib.chart.names.serviceAccountName" . }}
  labels: {{- include "common.labels" $ | nindent 4 }}
  {{- with (merge (.Values.serviceAccount.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
