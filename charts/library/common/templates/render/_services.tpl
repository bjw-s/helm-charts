{{/*
Renders the Service objects required by the chart.
*/}}
{{- define "bjw-s.common.render.services" -}}
  {{- /* Generate named services as required */ -}}
  {{- range $name, $service := .Values.service -}}
    {{- if $service.enabled -}}
      {{- $serviceValues := $service -}}

      {{/* set the default nameOverride to the service name */}}
      {{- if and (not $serviceValues.nameOverride) (ne $name (include "bjw-s.common.lib.util.service.primary" $)) -}}
        {{- $_ := set $serviceValues "nameOverride" $name -}}
      {{ end -}}

      {{/* Include the Service class */}}
      {{- $_ := set $ "ObjectValues" (dict "service" $serviceValues) -}}
      {{- include "bjw-s.common.class.service" $ | nindent 0 -}}

      {{/* Include a serviceMonitor if required */}}
      {{- if ($service.monitor).enabled | default false -}}
        {{- $_ := set $ "ObjectValues" (dict "serviceMonitor" $serviceValues.monitor) -}}
        {{- $_ := set $.ObjectValues.serviceMonitor "nameOverride" $serviceValues.nameOverride -}}

        {{- $serviceName := include "bjw-s.common.lib.chart.names.fullname" $ -}}
        {{- if and (hasKey $serviceValues "nameOverride") $serviceValues.nameOverride -}}
          {{- $serviceName = printf "%v-%v" $serviceName $serviceValues.nameOverride -}}
        {{ end -}}
        {{- $_ := set $.ObjectValues.serviceMonitor "serviceName" $serviceName -}}
        {{- include "bjw-s.common.class.serviceMonitor" $ | nindent 0 -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
