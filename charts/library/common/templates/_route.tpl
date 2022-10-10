{{/* Renders the Route objects required by the chart */}}
{{- define "common.route" -}}
  {{- /* Generate named routes as required */ -}}
  {{- range $name, $route := .Values.route }}
    {{- if $route.enabled -}}
      {{- $routeValues := $route -}}

      {{/* set defaults */}}
      {{- if not $routeValues.nameOverride -}}
        {{- $_ := set $routeValues "nameOverride" $name -}}
      {{- end -}}

      {{- $_ := set $ "ObjectValues" (dict "route" $routeValues) -}}
      {{- include "common.classes.route" $ | nindent 0 -}}
    {{- end }}
  {{- end }}
{{- end }}
