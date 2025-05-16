{{/*
Return a Route object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.route.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- $enabledRoutes := (include "bjw-s.common.lib.route.enabledRoutes" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledRoutes $identifier) -}}
    {{- $objectValues := get $enabledRoutes $identifier -}}
    {{- $object := include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledRoutes)) | fromYaml -}}

    {{- /* Try to automatically determine the default Service identifier if needed and possible */ -}}
    {{- if eq 1 (len $enabledServices) -}}
      {{- range $object.rules -}}
        {{- range .backendRefs }}
          {{- $backendRef := . -}}
          {{- if and (empty (dig "name" nil $backendRef)) (empty (dig "identifier" nil $backendRef)) -}}
            {{- $_ := set $backendRef "identifier" ($enabledServices | keys | first) -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}

    {{- $object | toYaml -}}
  {{- end -}}
{{- end -}}
