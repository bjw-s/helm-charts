{{/*
Validate Role values
*/}}
{{- define "bjw-s.common.lib.rbac.role.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $roleValues := .object -}}
  {{- $rules := $roleValues.rules -}}

  {{- if not $rules -}}
    {{- fail "Rules can't be empty" -}}
  {{- end -}}
{{- end -}}
