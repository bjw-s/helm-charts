{{/*
Convert controller values to an object
*/}}
{{- define "bjw-s.common.lib.controller.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Default the controller type to Deployment */ -}}
  {{- if empty (dig "type" nil $objectValues) -}}
    {{- $_ := set $objectValues "type" "deployment" -}}
  {{- end -}}

  {{- /* Determine and inject the controller name */ -}}
  {{- $objectName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $objectName = printf "%s-%s" $objectName $objectValues.nameOverride -}}
  {{- else -}}
    {{- if ne $identifier "main" -}}
      {{- $objectName = printf "%s-%s" $objectName $identifier -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Return the controller object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
