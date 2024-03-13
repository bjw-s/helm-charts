{{/*
Return a controller by its identifier.
*/}}
{{- define "bjw-s.common.lib.controller.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}

  {{- $enabledControllers := include "bjw-s.common.lib.controller.enabledControllers" (dict "rootContext" $rootContext) | fromYaml -}}
  {{- $controllerValues := get $enabledControllers $identifier -}}

  {{- if not (empty $controllerValues) -}}
    {{- include "bjw-s.common.lib.controller.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $controllerValues) -}}
  {{- end -}}
{{- end -}}
