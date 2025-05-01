{{/*
Return a Route object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.route.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledRoutes := (include "bjw-s.common.lib.route.enabledRoutes" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledRoutes $identifier) -}}
    {{- $objectValues := get $enabledRoutes $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledRoutes)) -}}
  {{- end -}}
{{- end -}}
