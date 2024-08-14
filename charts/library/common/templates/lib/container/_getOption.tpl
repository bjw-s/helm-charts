{{- /*
Returns the value for the specified field
*/ -}}
{{- define "bjw-s.common.lib.container.getOption" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $containerType := .ctx.containerType -}}
  {{- $controllerObject := .ctx.controllerObject -}}
  {{- $containerObject := .ctx.containerObject -}}
  {{- $option := .option -}}
  {{- $default := default "" .default -}}

  {{- $value := $default -}}

  {{- /* Apply default options by default */ -}}
  {{- $applyDefaultContainerOptions := true -}}

  {{- /* Allow disabling default options for initContainers */ -}}
  {{- if (eq "init" $containerType) -}}
    {{- if hasKey $controllerObject "applyDefaultContainerOptionsToInitContainers" -}}
      {{- $applyDefaultContainerOptions = $controllerObject.applyDefaultContainerOptionsToInitContainers -}}
    {{- end -}}
  {{- end -}}

  {{- /* Set to the default container option if it is set */ -}}
  {{- if (eq true $applyDefaultContainerOptions) -}}
    {{- $defaultOption := dig $option nil (default dict $controllerObject.defaultContainerOptions) -}}
    {{- if kindIs "bool" $defaultOption -}}
      {{- $value = $defaultOption -}}
    {{- else if not (empty $defaultOption) -}}
      {{- $value = $defaultOption -}}
    {{- end -}}
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
