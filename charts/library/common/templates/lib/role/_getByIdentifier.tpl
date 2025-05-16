{{/*
Return a Role Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.rbac.role.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledRoles := (include "bjw-s.common.lib.rbac.role.enabledRoles" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledRoles $identifier) -}}
    {{- $objectValues := get $enabledRoles $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledRoles)) -}}
  {{- end -}}
{{- end -}}
