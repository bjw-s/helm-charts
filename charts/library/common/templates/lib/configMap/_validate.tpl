{{/*
Validate configMap values
*/}}
{{- define "bjw-s.common.lib.configMap.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $configMapValues := .object -}}

  {{- if and (empty (get $configMapValues "data")) (empty (get $configMapValues "binaryData")) -}}
    {{- fail (printf "No data or binaryData specified for configMap. (configMap: %s)" $configMapValues.identifier) }}
  {{- end -}}
{{- end -}}
