{{/*
Convert container values to an object
*/}}
{{- define "bjw-s.common.lib.container.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Return the container object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
