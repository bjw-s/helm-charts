{{/*
Validate controller values
*/}}
{{- define "bjw-s.common.lib.controller.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $controllerValues := .object -}}

  {{- $allowedControllerTypes := list "deployment" "daemonset" "statefulset" "cronjob" -}}
  {{- if not (has $controllerValues.type $allowedControllerTypes) -}}
    {{- fail (printf "Not a valid controller.type (%s)" $controllerValues.type) -}}
  {{- end -}}
{{- end -}}
