{{/*
Return an Ingress Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.ingress.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $enabledIngresses := (include "bjw-s.common.lib.ingress.enabledIngresses" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledIngresses $identifier) -}}
    {{- $objectValues := get $enabledIngresses $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledIngresses)) -}}
  {{- end -}}
{{- end -}}
