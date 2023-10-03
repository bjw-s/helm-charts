{{/*
Convert container values to an object
*/}}
{{- define "bjw-s.common.lib.container.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Convert float64 image tags to string */ -}}
  {{- if kindIs "map" $objectValues.image -}}
    {{- $imageTag := dig "image" "tag" "" $objectValues -}}
    {{- if kindIs "float64" $imageTag -}}
      {{- $_ := set $objectValues.image "tag" ($imageTag | toString) -}}
    {{- end -}}
  {{- end -}}

  {{- /* Return the container object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
