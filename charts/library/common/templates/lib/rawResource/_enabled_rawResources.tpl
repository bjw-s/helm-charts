{{/*
Return the enabled raw resources.
*/}}
{{- define "bjw-s.common.lib.rawResource.enabledRawResources" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledRawResources := dict -}}

  {{- range $name, $resource := $rootContext.Values.rawResources -}}
    {{- if kindIs "map" $resource -}}
      {{- /* Enable Raw Resource by default, but allow override */ -}}
      {{- $resourceEnabled := true -}}
      {{- if hasKey $resource "enabled" -}}
        {{- $resourceEnabled = $resource.enabled -}}
      {{- end -}}

      {{- if $resourceEnabled -}}
        {{- $_ := set $enabledRawResources $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledRawResources | toYaml -}}
{{- end -}}
