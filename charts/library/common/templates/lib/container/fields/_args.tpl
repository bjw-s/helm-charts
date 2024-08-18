{{/*
Args used by the container.
*/}}
{{- define "bjw-s.common.lib.container.field.args" -}}
  {{- $ctx := .ctx -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- $argValues := include "bjw-s.common.lib.container.getOption" (dict "ctx" $ctx "option" "args") -}}
  {{/* This is a terrible hack because Helm otherwise doesn't understand how to decode the object */}}
  {{- $argValues = printf "args:\n%s" ($argValues | indent 2) | fromYaml -}}
  {{- $argValues = $argValues.args -}}

  {{- /* Default to empty list */ -}}
  {{- $args := list -}}

  {{- /* See if an override is desired */ -}}
  {{- if not (empty $argValues) -}}
    {{- if kindIs "string" $argValues -}}
      {{- $args = append $args $argValues -}}
    {{- else -}}
      {{- $args = $argValues -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $args) -}}
    {{- $args | toYaml -}}
  {{- end -}}
{{- end -}}
