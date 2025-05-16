{{/*
Renders the Service objects required by the chart.
*/}}
{{- define "bjw-s.common.render.services" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate named Services as required */ -}}
  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledServices -}}
    {{- /* Generate object from the raw service values */ -}}
    {{- $serviceObject := (include "bjw-s.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the Service before rendering */ -}}
    {{- include "bjw-s.common.lib.service.validate" (dict "rootContext" $rootContext "object" $serviceObject) -}}

    {{- /* Include the Service class */ -}}
    {{- include "bjw-s.common.class.service" (dict "rootContext" $rootContext "object" $serviceObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
