{{/*
Return the enabled controllers.
*/}}
{{- define "bjw-s.common.lib.controller.enabledControllers" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledControllers := dict -}}

  {{- range $name, $controller := $rootContext.Values.controllers -}}
    {{- if kindIs "map" $controller -}}
      {{- /* Enable by default, but allow override */ -}}
      {{- $controllerEnabled := true -}}
      {{- if hasKey $controller "enabled" -}}
        {{- $controllerEnabled = $controller.enabled -}}
      {{- end -}}

      {{- if $controllerEnabled -}}
        {{- $_ := set $enabledControllers $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledControllers | toYaml -}}
{{- end -}}
