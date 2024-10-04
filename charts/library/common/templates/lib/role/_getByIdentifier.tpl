{{/*
Return a Role Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.rbac.role.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $roleValues := dig $identifier nil $rootContext.Values.rbac.roles -}}
  {{- if not (empty $roleValues) -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $roleValues) -}}
  {{- end -}}
{{- end -}}
