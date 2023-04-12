{{/*
Renders the Persistent Volume Claim objects required by the chart.
*/}}
{{- define "bjw-s.common.render.pvcs" -}}
  {{- /* Generate pvc as required */ -}}
  {{- range $key, $pvc := .Values.persistence -}}
    {{- if and $pvc.enabled (eq (default "pvc" $pvc.type) "pvc") (not $pvc.existingClaim) -}}
      {{- $pvcValues := (mustDeepCopy $pvc) -}}

      {{/* Determine the PVC name */}}
      {{- $pvcName := (include "bjw-s.common.lib.chart.names.fullname" $) -}}
      {{- if $pvcValues.nameOverride -}}
        {{- if ne $pvcValues.nameOverride "-" -}}
          {{- $pvcName = printf "%s-%s" $pvcName $pvcValues.nameOverride -}}
        {{ end -}}
      {{- else -}}
        {{- $pvcName = printf "%s-%s" $pvcName $key -}}
      {{- end -}}
      {{- $_ := set $pvcValues "name" $pvcName -}}
      {{- $_ := set $pvcValues "key" $key -}}

      {{- /* Perform validations on the PVC before rendering */ -}}
      {{- include "bjw-s.common.lib.pvc.validate" (dict "rootContext" $ "object" $pvcValues) -}}

      {{- /* Include the PVC class */ -}}
      {{- include "bjw-s.common.class.pvc" (dict "rootContext" $ "object" $pvcValues) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
