{{- /* The main container included in the controller */ -}}
{{- define "common.controller.mainContainer" -}}
- name: {{ include "common.names.fullname" . }}
  image: {{ printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) | quote }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- with .Values.command }}
  command:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
      {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.args }}
  args:
    {{- if kindIs "string" . }}
    - {{ . }}
    {{- else }}
    {{ toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with .Values.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.lifecycle }}
  lifecycle:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.termination.messagePath }}
  terminationMessagePath: {{ . }}
  {{- end }}
  {{- with .Values.termination.messagePolicy }}
  terminationMessagePolicy: {{ . }}
  {{- end }}

  {{- with .Values.env }}
  env:
    {{- get (fromYaml (include "common.controller.env_vars" $)) "env" | toYaml | nindent 4 -}}
  {{- end }}
  {{- if or .Values.envFrom .Values.secret }}
  envFrom:
    {{- with .Values.envFrom }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- if .Values.secret }}
    - secretRef:
        name: {{ include "common.names.fullname" . }}
    {{- end }}
  {{- end }}
  ports:
  {{- include "common.controller.ports" . | trim | nindent 4 }}
  {{- with (include "common.controller.volumeMounts" . | trim) }}
  volumeMounts:
    {{- nindent 4 . }}
  {{- end }}
  {{- include "common.controller.probes" . | trim | nindent 2 }}
  {{- with .Values.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
