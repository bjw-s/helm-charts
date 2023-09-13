{{/*
Renders the Persistent Volume Claim objects required by the chart.
*/}}
{{- define "bjw-s.common.render.pvcs" -}}
  {{- /* Generate pvc as required */ -}}
  {{- range $key, $pvc := .Values.persistence -}}
    {{- if and $pvc.enabled (eq (default "persistentVolumeClaim" $pvc.type) "persistentVolumeClaim") (not $pvc.existingClaim) -}}
      {{- $pvcValues := (mustDeepCopy $pvc) -}}

      {{- /* Create object from the raw PVC values */ -}}
      {{- $pvcObject := (include "bjw-s.common.lib.pvc.valuesToObject" (dict "rootContext" $ "id" $key "values" $pvcValues)) | fromYaml -}}

      {{- /* Perform validations on the PVC before rendering */ -}}
      {{- include "bjw-s.common.lib.pvc.validate" (dict "rootContext" $ "object" $pvcValues) -}}

      {{- /* Include the PVC class */ -}}
      {{- include "bjw-s.common.class.pvc" (dict "rootContext" $ "object" $pvcValues) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
