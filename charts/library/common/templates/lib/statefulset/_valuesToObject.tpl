{{/*
Convert StatefulSet values to an object
*/}}
{{- define "bjw-s.common.lib.statefulset.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}
  {{- $itemCount := .itemCount -}}

  {{- $objectName := (include "bjw-s.common.lib.determineResourceNameFromValues" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" $itemCount)) -}}

  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- $strategy := default "RollingUpdate" $objectValues.strategy -}}
  {{- $_ := set $objectValues "strategy" $strategy -}}

  {{- $objectValues | toYaml -}}
{{- end -}}
