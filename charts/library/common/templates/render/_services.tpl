{{/*
Renders the Service objects required by the chart.
*/}}
{{- define "bjw-s.common.render.services" -}}
  {{- /* Generate named services as required */ -}}
  {{- range $name, $service := .Values.service -}}
    {{- if $service.enabled -}}
      {{- $serviceValues := $service -}}

      {{/* set the default nameOverride to the service name */}}
      {{- if and (not $serviceValues.nameOverride) (ne $name (include "bjw-s.common.lib.service.primary" $)) -}}
        {{- $_ := set $serviceValues "nameOverride" $name -}}
      {{ end -}}

      {{/* Include the Service class */}}
      {{- $_ := set $ "ObjectValues" (dict "service" $serviceValues) -}}
      {{- include "bjw-s.common.class.service" $ | nindent 0 -}}
      {{- $_ := unset $.ObjectValues "service" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
