{{/*
Return the enabled RoleBindings.
*/}}
{{- define "bjw-s.common.lib.rbac.roleBinding.enabledRoleBindings" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRoleBindings := dict -}}

  {{- range $name, $role := $rootContext.Values.rbac.bindings -}}
    {{- if kindIs "map" $role -}}
      {{- /* Enable Role by default, but allow override */ -}}
      {{- $roleEnabled := true -}}
      {{- if hasKey $role "enabled" -}}
        {{- $roleEnabled = $role.enabled -}}
      {{- end -}}

      {{- if $roleEnabled -}}
        {{- $_ := set $enabledRoleBindings $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledRoleBindings | toYaml -}}
{{- end -}}
