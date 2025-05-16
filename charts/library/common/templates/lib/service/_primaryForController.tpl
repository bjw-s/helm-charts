{{/*
Return the primary service object for a controller
*/}}
{{- define "bjw-s.common.lib.service.primaryForController" -}}
  {{- $rootContext := .rootContext -}}
  {{- $controllerIdentifier := .controllerIdentifier -}}

  {{- $serviceIdentifier := "" -}}
  {{- $result := dict -}}

  {{- /* Loop over all enabled services */ -}}
  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) }}
  {{- if $enabledServices -}}
    {{- /* We are only interested in services for the specified controller */ -}}
    {{- $enabledServicesForController := dict -}}
    {{- range $identifier, $serviceObject := $enabledServices -}}
      {{- if eq $serviceObject.controller $controllerIdentifier -}}
        {{- $_ := set $enabledServicesForController $identifier $serviceObject -}}
      {{- end -}}
    {{- end -}}

    {{- range $identifier, $serviceObject := $enabledServicesForController -}}
      {{- /* Determine the Service that has been marked as primary */ -}}
      {{- if $serviceObject.primary -}}
        {{- $serviceIdentifier = $identifier -}}
        {{- $result = $serviceObject -}}
      {{- end -}}

      {{- /* Return the first Service (alphabetically) if none has been explicitly marked as primary */ -}}
      {{- if not $result -}}
        {{- $firstServiceKey := keys $enabledServicesForController | sortAlpha | first -}}
        {{- $result = get $enabledServicesForController $firstServiceKey -}}
        {{- $serviceIdentifier = $identifier -}}
      {{- end -}}
    {{- end -}}

    {{- if not (empty $serviceIdentifier) -}}
      {{- include "bjw-s.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" $serviceIdentifier) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
