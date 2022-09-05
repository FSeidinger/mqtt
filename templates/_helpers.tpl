{{- define "configuredPort" -}}
    {{ .Values.configuration.listener.port | default 1883 }}
{{- end -}}