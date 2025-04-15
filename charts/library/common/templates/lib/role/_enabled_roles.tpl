{{/*
Return the enabled roles.
*/}}
{{- define "bjw-s.common.lib.rbac.role.enabledRoles" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRoles := dict -}}

  {{- range $name, $role := $rootContext.Values.rbac.roles -}}
    {{- if kindIs "map" $role -}}
      {{- /* Enable Role by default, but allow override */ -}}
      {{- $roleEnabled := true -}}
      {{- if hasKey $role "enabled" -}}
        {{- $roleEnabled = $role.enabled -}}
      {{- end -}}

      {{- if $roleEnabled -}}
        {{- $_ := set $enabledRoles $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledRoles | toYaml -}}
{{- end -}}
