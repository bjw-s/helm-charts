{{/*
Renders the Ingress objects required by the chart.
*/}}
{{- define "bjw-s.common.render.ingresses" -}}
  {{- /* Generate named Ingresses as required */ -}}
  {{- range $key, $ingress := .Values.ingress }}
    {{- if $ingress.enabled -}}
      {{- $ingressValues := (mustDeepCopy $ingress) -}}

      {{/* Determine the Ingress name */}}
      {{- $ingressName := (include "bjw-s.common.lib.chart.names.fullname" $) -}}
      {{- if $ingressValues.nameOverride -}}
        {{- $ingressName = printf "%s-%s" $ingressName $ingressValues.nameOverride -}}
      {{- else -}}
        {{- if not $ingressValues.primary -}}
          {{- $ingressName = printf "%s-%s" $ingressName $key -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $ingressValues "name" $ingressName -}}
      {{- $_ := set $ingressValues "key" $key -}}

      {{- /* Perform validations on the Service before rendering */ -}}
      {{- include "bjw-s.common.lib.ingress.validate" (dict "rootContext" $ "object" $ingressValues) -}}

      {{/* Include the Ingress class */}}
      {{- include "bjw-s.common.class.ingress" (dict "rootContext" $ "object" $ingressValues) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
