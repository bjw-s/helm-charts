{{/*
Env field used by the container.
*/}}
{{- define "bjw-s.common.lib.container.field.env" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- /* Default to empty list */ -}}
  {{- $env := list -}}

  {{- /* See if an override is desired */ -}}
  {{- if not (empty (get $containerObject "env")) -}}
    {{- with $containerObject.env -}}
      {{- range $name, $value := . -}}
        {{- if kindIs "int" $name -}}
          {{- $name = required "environment variables as a list of maps require a name field" $value.name -}}
        {{- end -}}

        {{- if kindIs "map" $value -}}
          {{- if hasKey $value "value" -}}
            {{- $envValue := $value.value | toString -}}
            {{- $env = append $env (dict "name" $name "value" (tpl $envValue $rootContext)) -}}
          {{- else if hasKey $value "valueFrom" -}}
            {{- $env = append $env (dict "name" $name "valueFrom" $value.valueFrom) -}}
          {{- else -}}
            {{- $env = append $env (dict "name" $name "valueFrom" $value) -}}
          {{- end -}}
        {{- else -}}
          {{- if kindIs "string" $value -}}
            {{- $env = append $env (dict "name" $name "value" (tpl $value $rootContext)) -}}
          {{- else if or (kindIs "float64" $value) (kindIs "bool" $value) -}}
            {{- $env = append $env (dict "name" $name "value" ($value | toString)) -}}
          {{- else -}}
            {{- $env = append $env (dict "name" $name "value" $value) -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $env) -}}
    {{- $env | toYaml -}}
  {{- end -}}
{{- end -}}
