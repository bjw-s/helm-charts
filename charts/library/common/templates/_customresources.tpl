{{/*
The custom resource objects to be created.
*/}}
{{- define "common.customresources" }}
{{- range .Values.customResources }}
---
{{ toYaml . -}}
{{- end }}
{{- range $i, $t := .Values.customTemplates }}
---
{{ toYaml (tpl $t $ | fromYaml) -}}
{{- end }}
{{- end }}
