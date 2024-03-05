{{- /*
Returns the value for the specified field
*/ -}}
{{- define "bjw-s.common.lib.pod.getOption" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}
  {{- $option := .option -}}
  {{- $default := default "" .default -}}

  {{- $value := $default -}}

  {{- /* Set to the default if it is set */ -}}
  {{- $defaultOption := dig $option nil (default dict $rootContext.Values.defaultPodOptions) -}}
  {{- if kindIs "bool" $defaultOption -}}
    {{- $value = $defaultOption -}}
  {{- else if not (empty $defaultOption) -}}
    {{- $value = $defaultOption -}}
  {{- end -}}

  {{- /* See if a pod-specific override is needed */ -}}
  {{- $podOption := dig $option nil (default dict $controllerObject.pod) -}}
  {{- if kindIs "bool" $podOption -}}
    {{- $value = $podOption -}}
  {{- else if not (empty $podOption) -}}
    {{- $value = $podOption -}}
  {{- end -}}

  {{- if kindIs "bool" $value -}}
    {{- $value | toYaml -}}
  {{- else if not (empty $value) -}}
    {{- $value | toYaml -}}
  {{- end -}}
{{- end -}}
