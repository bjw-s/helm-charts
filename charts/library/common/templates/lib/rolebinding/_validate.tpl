{{/*
Validate RoleBinding values
*/}}
{{- define "bjw-s.common.lib.rbac.roleBinding.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $roleBindingValues := .object -}}
  {{- $type := required "The binding needs to have an explicitly declared type" $roleBindingValues.type -}}
  {{- $typeList := list "RoleBinding" "ClusterRoleBinding" -}}
  {{- $subjects := $roleBindingValues.subjects -}}
  {{- $roleRef := required "A roleRef is required" $roleBindingValues.roleRef -}}

  {{- if not (mustHas $type $typeList) -}}
    {{- fail (printf "\nYou selected: `%s`. Type must be one of:\n%s\n" $type ($typeList|toYaml)) -}}
  {{- end -}}

  {{- if not (hasKey $roleRef "identifier") -}}
    {{- $name := required "If not using identifier roleRef must have a `name` key" $roleRef.name -}}
    {{- $name := required "If not using identifier roleRef must have a `kind` key" $roleRef.kind -}}
  {{- end -}}

  {{- range $subject := $subjects -}}
    {{- if not (hasKey . "identifier") -}}
      {{- if not (hasKey . "name") -}}
        {{- $name := required "If not using identifier a subject must have a `name` key" .name -}}
      {{- else if not (hasKey . "namespace") -}}
        {{- $namespace := required "If not using identifier a subject must have a `namespace` key" .namespace -}}
      {{- else if not (hasKey . "kind") -}}
        {{- $kind := required "If not using identifier a subject must have a `kind` key" .kind -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
