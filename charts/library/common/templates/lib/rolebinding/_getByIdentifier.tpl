{{/*
Return a RoleBinding Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.rbac.roleBinding.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $roleBindingValues := dig $identifier nil $rootContext.Values.rbac.bindings -}}
  {{- if not (empty $roleBindingValues) -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $roleBindingValues) -}}
  {{- end -}}
{{- end -}}
