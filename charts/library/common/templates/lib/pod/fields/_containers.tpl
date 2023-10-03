{{- /*
Returns the value for containers
*/ -}}
{{- define "bjw-s.common.lib.pod.field.containers" -}}
  {{- $rootContext := .ctx.rootContext -}}
  {{- $controllerObject := .ctx.controllerObject -}}

  {{- /* Default to empty list */ -}}
  {{- $orderedContainers := dict -}}
  {{- $containers := list -}}

  {{- /* Fetch configured containers for this controller */ -}}
  {{- $enabledContainers := include "bjw-s.common.lib.controller.enabledContainers" (dict "rootContext" $rootContext "controllerObject" $controllerObject) | fromYaml }}
  {{- range $key, $containerValues := $enabledContainers -}}
    {{- /* Create object from the container values */ -}}
    {{- $containerObject := (include "bjw-s.common.lib.container.valuesToObject" (dict "rootContext" $ "id" $key "values" $containerValues)) | fromYaml -}}

    {{- /* Perform validations on the Container before rendering */ -}}
    {{- include "bjw-s.common.lib.container.validate" (dict "rootContext" $ "controllerObject" $controllerObject "containerObject" $containerObject) -}}

    {{- /* Generate the Container spec */ -}}
    {{- $renderedContainer := include "bjw-s.common.lib.container.spec" (dict "rootContext" $rootContext "controllerObject" $controllerObject "containerObject" $containerObject) | fromYaml -}}

    {{- $containerOrder := (dig "order" 99 $containerValues) -}}
    {{- $_ := set $orderedContainers (printf "%v-%s" $containerOrder $key) $renderedContainer -}}
  {{- end -}}

  {{- range $key, $containerValues := $orderedContainers -}}
    {{- $containers = append $containers $containerValues -}}
  {{- end -}}

  {{- if not (empty $containers) -}}
    {{- $containers | toYaml -}}
  {{- end -}}
{{- end -}}
