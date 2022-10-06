{{/* vim: set filetype=mustache: */}}
{{/*
Shared secret for the discord server
*/}}
{{- define "matrix.discord.as_token" -}}
{{- randAlphaNum 64 -}}
{{- end -}}

{{- define "matrix.discord.hs_token" -}}
{{- randAlphaNum 64 -}}
{{- end -}}
