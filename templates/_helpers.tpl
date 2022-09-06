{{- define "configuredPort" -}}
    {{ .Values.configuration.listener.port | default 1883 }}
{{- end -}}

{{- define "configuredAddress" -}}
    {{ .Values.configuration.listener.address }}
{{- end -}}