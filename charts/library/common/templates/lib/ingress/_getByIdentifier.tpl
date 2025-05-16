{{/*
Return an Ingress Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.ingress.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- $enabledIngresses := (include "bjw-s.common.lib.ingress.enabledIngresses" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledIngresses $identifier) -}}
    {{- $objectValues := get $enabledIngresses $identifier -}}
    {{- $object := include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledIngresses)) | fromYaml -}}

    {{- /* Try to automatically determine the default Service identifier if needed and possible */ -}}
    {{- if eq 1 (len $enabledServices) -}}
      {{- range $object.hosts -}}
        {{- range .paths -}}
          {{- if not (has "service" (keys .)) -}}
            {{- $_ := set . "service" (dict "identifier" ($enabledServices | keys | first)) -}}
          {{- else if and (not .service.name) (not .service.identifier) -}}
            {{- $_ := set .service "identifier" ($enabledServices | keys | first) -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}

    {{- $object | toYaml -}}
  {{- end -}}
{{- end -}}
