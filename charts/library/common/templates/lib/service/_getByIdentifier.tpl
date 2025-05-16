{{/*
Return a service Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.service.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) }}
  {{- $enabledControllers := (include "bjw-s.common.lib.controller.enabledControllers" (dict "rootContext" $rootContext) | fromYaml ) -}}

  {{- if (hasKey $enabledServices $identifier) -}}
    {{- $objectValues := get $enabledServices $identifier -}}
    {{- $object := include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledServices)) | fromYaml -}}

    {{- if eq 1 (len $enabledControllers) -}}
      {{- if (empty (dig "controller" nil $object)) -}}
        {{- $_ := set $object "controller" ($enabledControllers | keys | first) -}}
      {{- end -}}
    {{- end -}}

    {{- $object | toYaml -}}
  {{- end -}}
{{- end -}}
