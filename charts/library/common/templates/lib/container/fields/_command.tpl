{{/*
Command used by the container.
*/}}
{{- define "bjw-s.common.lib.container.field.command" -}}
  {{- $ctx := .ctx -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- $commandValues := include "bjw-s.common.lib.container.getOption" (dict "ctx" $ctx "option" "command") -}}
  {{/* This is a terrible hack because Helm otherwise doesn't understand how to decode the object */}}
  {{- $commandValues = printf "command:\n%s" ($commandValues | indent 2) | fromYaml -}}
  {{- $commandValues = $commandValues.command -}}

  {{- /* Default to empty list */ -}}
  {{- $command := list -}}

  {{- /* See if an override is desired */ -}}
  {{- if not (empty $commandValues) -}}
    {{- if kindIs "string" $commandValues -}}
      {{- $command = append $command $commandValues -}}
    {{- else -}}
      {{- $command = $commandValues -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $command) -}}
    {{- $command | toYaml -}}
  {{- end -}}
{{- end -}}
