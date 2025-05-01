{{/*
Return a PVC object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.pvc.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledPVCs := (include "bjw-s.common.lib.pvc.enabledPVCs" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledPVCs $identifier) -}}
    {{- $objectValues := get $enabledPVCs $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledPVCs)) -}}
  {{- end -}}
{{- end -}}
