{{/*
Renders RBAC objects required by the chart.
*/}}
{{- define "bjw-s.common.render.rbac" -}}
  {{- $rootContext := . -}}
  {{- include "bjw-s.common.render.rbac.roles" (dict "rootContext" $rootContext) -}}

  {{- include "bjw-s.common.render.rbac.roleBindings" (dict "rootContext" $rootContext) -}}

{{ end }}

{{/*
Renders RBAC Role objects required by the chart.
*/}}
{{- define "bjw-s.common.render.rbac.roles" -}}
  {{- $rootContext := .rootContext -}}
  {{- /* Generate named Roles as required */ -}}
  {{- range $key, $role := $rootContext.Values.rbac.roles }}
    {{- /* Enable role by default, but allow override */ -}}
    {{- $roleEnabled := true -}}
    {{- if hasKey $role "enabled" -}}
      {{- $roleEnabled = $role.enabled -}}
    {{- end -}}

    {{- if $roleEnabled -}}
      {{- $roleValues := (mustDeepCopy $role) -}}

      {{- /* Create object from the raw role values */ -}}
      {{- $roleObject := (include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $key "values" $roleValues)) | fromYaml -}}

      {{- /* Perform validations on the role before rendering */ -}}
      {{- include "bjw-s.common.lib.rbac.role.validate" (dict "rootContext" $rootContext "object" $roleObject) -}}

      {{/* Include the role class */}}
      {{- include "bjw-s.common.class.rbac.Role" (dict "rootContext" $rootContext "object" $roleObject) | nindent 0 -}}

    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Renders RBAC RoleBinding objects required by the chart.
*/}}
{{- define "bjw-s.common.render.rbac.roleBindings" -}}
  {{- $rootContext := .rootContext -}}
  {{- range $key, $roleBinding := $rootContext.Values.rbac.bindings }}
    {{- /* Enable RoleBinding by default, but allow override */ -}}
    {{- $roleBindingEnabled := true -}}
    {{- if hasKey $roleBinding "enabled" -}}
      {{- $roleBindingEnabled = $roleBinding.enabled -}}
    {{- end -}}

    {{- if $roleBindingEnabled -}}
      {{- $roleBindingValues := (mustDeepCopy $roleBinding) -}}

      {{- /* Create object from the raw RoleBinding values */ -}}
      {{- $roleBindingObject := (include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $key "values" $roleBindingValues)) | fromYaml -}}

      {{- /* Perform validations on the RoleBinding before rendering */ -}}
      {{- include "bjw-s.common.lib.rbac.roleBinding.validate" (dict "rootContext" $rootContext "object" $roleBindingObject) -}}

      {{/* Include the RoleBinding class */}}
      {{- include "bjw-s.common.class.rbac.roleBinding" (dict "rootContext" $rootContext "object" $roleBindingObject) | nindent 0 -}}

    {{- end -}}
  {{- end -}}
{{- end -}}
