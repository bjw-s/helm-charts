{{/*
Renders other arbirtrary objects required by the chart.
*/}}
{{- define "bjw-s.common.render.rawResources" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate raw resources as required */ -}}
  {{- range $key, $resource := .Values.rawResources -}}
    {{- /* Enable by default, but allow override */ -}}
    {{- $resourceEnabled := true -}}
    {{- if hasKey $resource "enabled" -}}
      {{- $resourceEnabled = $resource.enabled -}}
    {{- end -}}

    {{- if $resourceEnabled -}}
      {{- $resourceValues := (mustDeepCopy $resource) -}}

      {{- /* Create object from the raw resource values */ -}}
      {{- $resourceObject := (include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $key "values" $resourceValues)) | fromYaml -}}

      {{- /* Perform validations on the resource before rendering */ -}}
      {{- include "bjw-s.common.lib.rawResource.validate" (dict "rootContext" $ "object" $resourceValues) -}}

      {{- /* Include the raw resource class */ -}}
      {{- include "bjw-s.common.class.rawResource" (dict "rootContext" $ "object" $resourceValues) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
