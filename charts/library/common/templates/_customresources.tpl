{{/*
The custom resource objects to be created.
*/}}
{{- define "common.customresources" }}
  {{- range .Values.customResources }}
---{{- (tpl . $)  | nindent 0 }}
  {{- end }}
{{- end }}
