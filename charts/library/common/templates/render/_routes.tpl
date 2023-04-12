{{/* Renders the Route objects required by the chart */}}
{{- define "bjw-s.common.render.routes" -}}
  {{- /* Generate named routes as required */ -}}
  {{- range $key, $route := .Values.route }}
    {{- if $route.enabled -}}
      {{- $routeValues := (mustDeepCopy $route) -}}

      {{/* Determine the Route name */}}
      {{- $routeName := (include "bjw-s.common.lib.chart.names.fullname" $) -}}
      {{- if $routeValues.nameOverride -}}
        {{- $routeName = printf "%s-%s" $routeName $routeValues.nameOverride -}}
      {{- else -}}
        {{- if ne $key (include "bjw-s.common.lib.route.primary" $) -}}
          {{- $routeName = printf "%s-%s" $routeName $key -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $routeValues "name" $routeName -}}

      {{- /* Perform validations on the Route before rendering */ -}}
      {{- include "bjw-s.common.lib.route.validate" (dict "rootContext" $ "object" $routeValues) -}}

      {{- /* Include the Route class */ -}}
      {{- include "bjw-s.common.class.route" (dict "rootContext" $ "object" $routeValues) | nindent 0 -}}
    {{- end }}
  {{- end }}
{{- end }}
