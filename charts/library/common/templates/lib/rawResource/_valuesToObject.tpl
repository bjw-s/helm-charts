{{/*
Convert raw resource values to an object
*/}}
{{- define "bjw-s.common.lib.rawResource.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the raw resource name */ -}}
  {{- $objectName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $rootContext -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- if not (eq $objectName $identifier) -}}
      {{- $objectName = printf "%s-%s" $objectName $identifier -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Return the raw resource object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
