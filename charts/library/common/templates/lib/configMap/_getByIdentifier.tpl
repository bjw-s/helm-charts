{{/*
Return a configMap Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.configMap.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledConfigMaps := (include "bjw-s.common.lib.configMap.enabledConfigmaps" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledConfigMaps $identifier) -}}
    {{- $objectValues := get $enabledConfigMaps $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledConfigMaps)) -}}
  {{- end -}}
{{- end -}}
