{{/*
Validate Role values
*/}}
{{- define "bjw-s.common.lib.rbac.role.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $roleValues := .object -}}
  {{- $type := required "The role needs to have an explicitly declared type" $roleValues.type -}}
  {{- $typeList := list "Role" "ClusterRole" -}}
  {{- $rules := $roleValues.rules -}}

  {{- if not (mustHas $type $typeList) -}}
    {{- fail (printf "\nYou selected: `%s`. Type must be one of:\n%s\n" $type ($typeList|toYaml)) -}}
  {{- end -}}
  {{- if not $rules -}}
    {{- fail "Rules can't be empty" -}}
  {{- end -}}

{{- end -}}
