{{/*
Return a RoleBinding Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.rbac.roleBinding.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledRoleBindings := (include "bjw-s.common.lib.rbac.roleBinding.enabledRoleBindings" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledRoleBindings $identifier) -}}
    {{- $objectValues := get $enabledRoleBindings $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledRoleBindings)) -}}
  {{- end -}}
{{- end -}}
