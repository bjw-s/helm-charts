{{/* Renders the Route objects required by the chart */}}
{{- define "bjw-s.common.render.routes" -}}
  {{- /* Generate named routes as required */ -}}
  {{- range $name, $route := .Values.route }}
    {{- if $route.enabled -}}
      {{- $routeValues := $route -}}

      {{/* set defaults */}}
      {{- if not $routeValues.nameOverride -}}
        {{- $_ := set $routeValues "nameOverride" $name -}}
      {{- end -}}

      {{- $_ := set $ "ObjectValues" (dict "route" $routeValues) -}}
      {{- include "bjw-s.common.class.route" $ | nindent 0 -}}
      {{- $_ := unset $.ObjectValues "route" -}}
    {{- end }}
  {{- end }}
{{- end }}
