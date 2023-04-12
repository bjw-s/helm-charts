{{/*
Validate Service values
*/}}
{{- define "bjw-s.common.lib.service.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $serviceObject := .object -}}

  {{- /* Validate Service type */ -}}
  {{- $validServiceTypes := (list "ClusterIP" "LoadBalancer" "NodePort" "ExternalName" "ExternalIP") -}}
  {{- if and $serviceObject.type (not (mustHas $serviceObject.type $validServiceTypes)) -}}
    {{- fail (
      printf "invalid service type \"%s\" for Service with key \"%s\". Allowed values are [%s]"
      $serviceObject.type
      $serviceObject.key
      (join ", " $validServiceTypes)
    ) -}}
  {{- end -}}

  {{- if ne $serviceObject.type "ExternalName" -}}
    {{- $enabledPorts := include "bjw-s.common.lib.service.enabledPorts" (dict "rootContext" $rootContext "object" $serviceObject) | fromYaml }}
    {{- /* Validate at least one port is enabled */ -}}
    {{- if not $enabledPorts -}}
      {{- fail (printf "no ports are enabled for Service with key \"%s\"" $serviceObject.key) -}}
    {{- end -}}

    {{- range $name, $port := $enabledPorts -}}
      {{- /* Validate a port number is configured */ -}}
      {{- if not $port.port -}}
        {{- fail (printf "no port number is configured for port \"%s\" under Service with key \"%s\"" $name $serviceObject.key) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
