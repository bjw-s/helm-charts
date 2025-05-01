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
  {{- $enabledRoles := (include "bjw-s.common.lib.rbac.role.enabledRoles" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRoles -}}
    {{- /* Generate object from the raw role values */ -}}
    {{- $roleObject := (include "bjw-s.common.lib.rbac.role.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the role before rendering */ -}}
    {{- include "bjw-s.common.lib.rbac.role.validate" (dict "rootContext" $rootContext "object" $roleObject) -}}

    {{/* Include the role class */}}
    {{- include "bjw-s.common.class.rbac.Role" (dict "rootContext" $rootContext "object" $roleObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}

{{/*
Renders RBAC RoleBinding objects required by the chart.
*/}}
{{- define "bjw-s.common.render.rbac.roleBindings" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRoleBindings := (include "bjw-s.common.lib.rbac.roleBinding.enabledRoleBindings" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRoleBindings -}}
    {{- /* Generate object from the raw role values */ -}}
    {{- $roleBindingObject := (include "bjw-s.common.lib.rbac.roleBinding.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{/* Include the RoleBinding class */}}
    {{- include "bjw-s.common.class.rbac.roleBinding" (dict "rootContext" $rootContext "object" $roleBindingObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
