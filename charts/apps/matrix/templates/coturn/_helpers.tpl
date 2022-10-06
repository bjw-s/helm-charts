{{/* vim: set filetype=mustache: */}}
{{/*
Shared secret for the Coturn server
*/}}
{{- define "matrix.coturn.sharedSecret" -}}
{{- if .Values.coturn.sharedSecret }}
{{- .Values.coturn.sharedSecret -}}
{{- else }}
{{- randAlphaNum 64 -}}
{{- end }}
{{- end -}}
