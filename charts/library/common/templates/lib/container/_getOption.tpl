{{- /*
Returns the value for the specified field
*/ -}}
{{- define "bjw-s.common.lib.container.getOption" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}
  {{- $containerObject := .ctx.containerObject -}}
  {{- $option := .option -}}
  {{- $default := default "" .default -}}

  {{- $value := $default -}}

  {{- /* Set to the default if it is set */ -}}
  {{- $defaultOption := dig $option nil (default dict $controllerObject.defaultContainerOptions) -}}
  {{- if kindIs "bool" $defaultOption -}}
    {{- $value = $defaultOption -}}
  {{- else if not (empty $defaultOption) -}}
    {{- $value = $defaultOption -}}
  {{- end -}}

  {{- /* See if a container-specific override is needed */ -}}
  {{- $containerOption := dig $option nil (default dict $containerObject) -}}
  {{- if kindIs "bool" $containerOption -}}
    {{- $value = $containerOption -}}
  {{- else if not (empty $containerOption) -}}
    {{- $value = $containerOption -}}
  {{- end -}}

  {{- if kindIs "bool" $value -}}
    {{- $value | toYaml -}}
  {{- else if not (empty $value) -}}
    {{- $value | toYaml -}}
  {{- end -}}
{{- end -}}
