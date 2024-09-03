{{/*
Convert ServiceAccount values to an object
*/}}
{{- define "bjw-s.common.lib.serviceAccount.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the serviceAccount name */ -}}
  {{- $defaultServiceAccountName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- $objectName := $defaultServiceAccountName -}}

  {{- with $objectValues.name -}}
    {{- $objectName = . -}}
  {{- end -}}
  {{- if and (ne $identifier "default") (not $objectValues.name) -}}
    {{- $objectName = printf "%s-%s" $defaultServiceAccountName $identifier -}}
  {{- end -}}

  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}
  {{- /* Return the serviceAccount object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
