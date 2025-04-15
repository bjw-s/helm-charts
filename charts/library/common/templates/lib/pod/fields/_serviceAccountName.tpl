{{- /*
Returns the value for serviceAccountName
*/ -}}
{{- define "bjw-s.common.lib.pod.field.serviceAccountName" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}
  {{- $serviceAccountName := "default" -}}

  {{- with $controllerObject.serviceAccount -}}
    {{- if hasKey . "identifier" -}}
      {{- $subject := (include "bjw-s.common.lib.serviceAccount.getByIdentifier" (dict "rootContext" $rootContext "id" .identifier) | fromYaml) -}}

      {{- if not $subject }}
        {{- fail (printf "No enabled ServiceAccount found with this identifier. (controller: '%s', identifier: '%s')" $controllerObject.identifier .identifier) -}}
      {{- end -}}

      {{- $serviceAccountName = get $subject "name" -}}
    {{- else if hasKey . "name" -}}
      {{- $serviceAccountName = .name -}}
    {{- end -}}
  {{- end -}}
  {{- $serviceAccountName -}}
{{- end -}}
