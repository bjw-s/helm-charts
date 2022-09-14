{{/*
Renders the Service objects required by the chart.
*/}}
{{- define "common.service" -}}
  {{- /* Generate named services as required */ -}}
  {{- range $name, $service := .Values.service -}}
    {{- if $service.enabled -}}
      {{- $serviceValues := $service -}}

      {{/* set the default nameOverride to the service name */}}
      {{- if and (not $serviceValues.nameOverride) (ne $name (include "common.service.primary" $)) -}}
        {{- $_ := set $serviceValues "nameOverride" $name -}}
      {{ end -}}

      {{/* Include the Service class */}}
      {{- $_ := set $ "ObjectValues" (dict "service" $serviceValues) -}}
      {{- include "common.classes.service" $ | nindent 0 -}}

      {{/* Include a serviceMonitor if required */}}
      {{- if $service.monitor.enabled | default false -}}
        {{- $_ := set $ "ObjectValues" (dict "serviceMonitor" $serviceValues.monitor) -}}
        {{- $_ := set $.ObjectValues.serviceMonitor "nameOverride" $serviceValues.nameOverride -}}

        {{- $serviceName := include "common.names.fullname" $ -}}
        {{- if and (hasKey $serviceValues "nameOverride") $serviceValues.nameOverride -}}
          {{- $serviceName = printf "%v-%v" $serviceName $serviceValues.nameOverride -}}
        {{ end -}}
        {{- $_ := set $.ObjectValues.serviceMonitor "serviceName" $serviceName -}}
        {{- include "common.classes.serviceMonitor" $ | nindent 0 -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end }}

{{/*
Return the primary service object
*/}}
{{- define "common.service.primary" -}}
  {{- $enabledServices := dict -}}
  {{- range $name, $service := .Values.service -}}
    {{- if $service.enabled -}}
      {{- $_ := set $enabledServices $name . -}}
    {{- end -}}
  {{- end -}}

  {{- $result := "" -}}
  {{- range $name, $service := $enabledServices -}}
    {{- if and (hasKey $service "primary") $service.primary -}}
      {{- $result = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys $enabledServices | first -}}
  {{- end -}}
  {{- $result -}}
{{- end -}}
