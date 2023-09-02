{{/*
volumeMounts used by the container.
*/}}
{{- define "bjw-s.common.lib.container.field.volumeMounts" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $controllerObject := $ctx.controllerObject -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- /* Default to empty dict */ -}}
  {{- $enabledVolumeMounts := list -}}

  {{- /* TODO: Rework to put "mounts" under container specs */ -}}
  {{- /* TODO: Or rework to put "persistence" under controller spec */ -}}

  {{- range $persistenceIdentifier, $persistenceValues := $rootContext.Values.persistence -}}
    {{- $persistenceEnabled := true -}}
    {{- if hasKey $persistenceValues "enabled" -}}
      {{- $persistenceEnabled = $persistenceValues.enabled -}}
    {{- end -}}

    {{- if $persistenceEnabled -}}
      {{- /* Loop over mounts */ -}}
      {{- range .mounts -}}
        {{- if or (has $controllerObject.persistenceIdentifier .controllers) (has "_all_" .controllers) -}}
          {{- $volumeMount := dict -}}
          {{- $_ := set $volumeMount "name" $persistenceIdentifier -}}

          {{- /* Set the default mountPath to /<name_of_the_peristence_item> */ -}}
          {{- $mountPath := (printf "/%v" $persistenceIdentifier) -}}
          {{- if eq "hostPath" (default "pvc" $persistenceValues.type) -}}
            {{- $mountPath = $persistenceValues.hostPath -}}
          {{- end -}}
          {{- /* Use the specified mountPath if provided */ -}}
          {{- with $persistenceValues.mountPath -}}
            {{- $mountPath = . -}}
          {{- end -}}
          {{- $_ := set $volumeMount "mountPath" $mountPath -}}

          {{- $enabledVolumeMounts = append $enabledVolumeMounts $volumeMount -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- with $enabledVolumeMounts -}}
    {{- . | toYaml -}}
  {{- end -}}
{{- end -}}
