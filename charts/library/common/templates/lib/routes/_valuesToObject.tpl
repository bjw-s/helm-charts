{{/*
Convert Route values to an object
*/}}
{{- define "bjw-s.common.lib.route.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the Route name */ -}}
  {{- $objectName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $rootContext -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- $enabledRoutes := (include "bjw-s.common.lib.route.enabledRoutes" (dict "rootContext" $rootContext) | fromYaml ) }}
    {{- if and (not $objectValues.primary) (gt (len $enabledRoutes) 1) -}}
      {{- if not (eq $objectName $identifier) -}}
        {{- $objectName = printf "%s-%s" $objectName $identifier -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Return the Route object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
