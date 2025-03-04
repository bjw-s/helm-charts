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
    {{- /* We are only interested in services for the specified controller */ -}}
    {{- $enabledServicesForController := dict -}}
    {{- range $name, $service := $enabledServices -}}
      {{- if eq $service.controller $controllerIdentifier -}}
        {{- $_ := set $enabledServicesForController $name $service -}}
      {{- end -}}
    {{- end -}}

    {{- range $name, $service := $enabledServicesForController -}}
      {{- /* Determine the Service that has been marked as primary */ -}}
      {{- if $service.primary -}}
        {{- $identifier = $name -}}
        {{- $result = $service -}}
      {{- end -}}

      {{- /* Return the first Service (alphabetically) if none has been explicitly marked as primary */ -}}
      {{- if not $result -}}
        {{- $firstServiceKey := keys $enabledServicesForController | sortAlpha | first -}}
        {{- $result = get $enabledServicesForController $firstServiceKey -}}
        {{- $identifier = $result.identifier -}}
      {{- end -}}
    {{- end -}}

    {{- include "bjw-s.common.lib.service.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $result) -}}
  {{- end -}}
{{- end -}}
