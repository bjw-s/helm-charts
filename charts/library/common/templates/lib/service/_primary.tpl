{{/*
Return the primary service object
*/}}
{{- define "bjw-s.common.lib.service.primary" -}}
  {{- $result := dict -}}

  {{- /* Loop over all enabled services */ -}}
  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" $ | fromYaml ) }}
  {{- if $enabledServices -}}
    {{- range $name, $service := $enabledServices -}}
      {{- /* Determine the Service that has been marked as primary */ -}}
      {{- if and (hasKey $service "primary") $service.primary -}}
        {{- $result = $service -}}
      {{- end -}}
    {{- end -}}

    {{- /* Return the first Service if none has been explicitly marked as primary */ -}}
    {{- if not $result -}}
      {{- $firstServiceKey := keys $enabledServices | first -}}
      {{- $result = get $enabledServices $firstServiceKey -}}
    {{- end -}}

    {{- include "bjw-s.common.lib.service.massage" (dict "rootContext" $ "object" $result) -}}
  {{- end -}}
{{- end -}}
