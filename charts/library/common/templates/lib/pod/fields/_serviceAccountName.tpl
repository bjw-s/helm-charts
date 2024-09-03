{{- /*
Returns the value for serviceAccountName
*/ -}}
{{- define "bjw-s.common.lib.pod.field.serviceAccountName" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}

  {{- $serviceAccountName := get (include "bjw-s.common.lib.serviceAccount.getByIdentifier" (dict "rootContext" $rootContext "id" "default") | fromYaml) "name" -}}
  {{- with $controllerObject.serviceAccount -}}
    {{- if hasKey . "identifier" -}}
      {{- $serviceAccountName = get (include "bjw-s.common.lib.serviceAccount.getByIdentifier" (dict "rootContext" $rootContext "id" .identifier) | fromYaml) "name" -}}
    {{- else if hasKey . "name" -}}
      {{- $serviceAccountName = .name -}}
    {{- end -}}
  {{- end -}}
  {{- $serviceAccountName -}}

{{- end -}}
