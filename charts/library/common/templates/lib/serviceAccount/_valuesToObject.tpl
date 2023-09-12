{{/*
Convert Secret values to an object
*/}}
{{- define "bjw-s.common.lib.serviceAccount.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the serviceAccount name */ -}}
  {{- $objectName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $objectValues.name -}}
    {{- $objectName = $objectValues.name -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Return the serviceAccount object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
