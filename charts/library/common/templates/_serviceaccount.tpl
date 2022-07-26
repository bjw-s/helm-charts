{{/*
The ServiceAccount object to be created.
*/}}
{{- define "common.serviceAccount" }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "common.names.serviceAccountName" . }}
  labels: {{- include "common.labels" $ | nindent 4 }}
  {{- with (merge (.Values.serviceAccount.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
