{{/*
Validate container values
*/}}
{{- define "bjw-s.common.lib.container.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $containerValues := .object -}}

  {{- if eq (dig "image" "repository" "" $containerValues) ""  -}}
    {{- fail (printf "No image repository specified for container. (controller: %s, container: %s)" $containerValues.controller $containerValues.identifier) }}
  {{- end -}}
{{- end -}}
