{{/*
Massage Service values
*/}}
{{- define "bjw-s.common.lib.service.massage" -}}
  {{- $rootContext := .rootContext -}}
  {{- $serviceKey := .key -}}
  {{- $serviceValues := .object -}}

  {{- /* Determine and inject the Service name */ -}}
  {{- $serviceName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $serviceValues.nameOverride -}}
    {{- $serviceName = printf "%s-%s" $serviceName $serviceValues.nameOverride -}}
  {{- else -}}
    {{- if not $serviceValues.primary -}}
      {{- $serviceName = printf "%s-%s" $serviceName $serviceKey -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $serviceValues "name" $serviceName -}}
  {{- $_ := set $serviceValues "key" $serviceKey -}}

  {{- /* Return the massaged Service */ -}}
  {{- $serviceValues | toYaml -}}
{{- end -}}
