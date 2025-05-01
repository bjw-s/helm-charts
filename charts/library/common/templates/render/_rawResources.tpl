{{/*
Renders other arbirtrary objects required by the chart.
*/}}
{{- define "bjw-s.common.render.rawResources" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate raw resources as required */ -}}
  {{- $enabledRawResources := (include "bjw-s.common.lib.rawResource.enabledRawResources" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledRawResources -}}
    {{- /* Generate object from the raw resource values */ -}}
    {{- $rawResourceObject := (include "bjw-s.common.lib.rawResource.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Include the raw resource class */ -}}
    {{- include "bjw-s.common.class.rawResource" (dict "rootContext" $rootContext "object" $rawResourceObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
