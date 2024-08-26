{{/*
Command used by the container.
*/}}
{{- define "bjw-s.common.lib.container.field.command" -}}
  {{- $ctx := .ctx -}}
  {{- $containerObject := $ctx.containerObject -}}
  {{- $commandValues := get $containerObject "command" -}}

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
