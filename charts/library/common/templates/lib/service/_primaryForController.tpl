{{/*
Return the primary service object for a controller
*/}}
{{- define "bjw-s.common.lib.service.primaryForController" -}}
  {{- $rootContext := .rootContext -}}
  {{- $controllerIdentifier := .controllerIdentifier -}}

  {{- $identifier := "" -}}
  {{- $result := dict -}}

  {{- /* Loop over all enabled services */ -}}
  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) }}
  {{- if $enabledServices -}}
    {{- range $name, $service := $enabledServices -}}
      {{- /* Determine the Service that has been marked as primary */ -}}
      {{- if and (eq $service.controller $controllerIdentifier) $service.primary -}}
        {{- $identifier = $name -}}
        {{- $result = $service -}}
      {{- end -}}
    {{- end -}}

    {{- /* Return the first Service if none has been explicitly marked as primary */ -}}
    {{- if not $result -}}
      {{- range $name, $service := $enabledServices -}}
        {{- if and (not $result) (eq $service.controller $controllerIdentifier) -}}
          {{- $identifier = $name -}}
          {{- $result = $service -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}

    {{- include "bjw-s.common.lib.service.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $result) -}}
  {{- end -}}
{{- end -}}
