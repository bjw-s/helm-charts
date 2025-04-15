{{/*
Renders the Persistent Volume Claim objects required by the chart
*/}}
{{- define "bjw-s.common.render.pvcs" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate pvc as required */ -}}
  {{- $enabledPVCs := (include "bjw-s.common.lib.pvc.enabledPVCs" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledPVCs -}}
    {{- /* Generate object from the raw persistence values */ -}}
    {{- $pvcObject := (include "bjw-s.common.lib.pvc.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Include the PVC class */ -}}
    {{- include "bjw-s.common.class.pvc" (dict "rootContext" $rootContext "object" $pvcObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
