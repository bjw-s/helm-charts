{{/* vim: set filetype=mustache: */}}
{{/*
Shared secret for the irc server
*/}}
{{- define "matrix.irc.as_token" -}}
{{- randAlphaNum 64 -}}
{{- end }}

{{- define "matrix.irc.hs_token" -}}
{{- randAlphaNum 64 -}}
{{- end }}

{{- define "matrix.irc.passkey" -}}
{{- genPrivateKey "rsa" -}}
{{- end -}}