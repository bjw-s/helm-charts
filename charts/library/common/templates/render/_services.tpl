{{/*
Renders the Service objects required by the chart.
*/}}
{{- define "bjw-s.common.render.services" -}}
  {{- /* Generate named Services as required */ -}}
  {{- range $key, $svc := .Values.service -}}
    {{- /* Enable Service by default, but allow override */ -}}
    {{- $serviceEnabled := true -}}
    {{- if hasKey $svc "enabled" -}}
      {{- $serviceEnabled = $svc.enabled -}}
    {{- end -}}

    {{- if $serviceEnabled -}}
      {{- $serviceValues := (mustDeepCopy $svc) -}}

      {{- /* Massage the raw Service values */ -}}
      {{- $serviceValues = (include "bjw-s.common.lib.service.massage" (dict "rootContext" $ "key" $key "object" $serviceValues)) | fromYaml -}}

      {{- /* Perform validations on the Service before rendering */ -}}
      {{- include "bjw-s.common.lib.service.validate" (dict "rootContext" $ "object" $serviceValues) -}}

      {{- /* Include the Service class */ -}}
      {{- include "bjw-s.common.class.service" (dict "rootContext" $ "object" $serviceValues) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
