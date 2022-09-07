# mqtt

This is a simple helm chart to install an Eclipse mosquitto based MQTT service in your K3S kubernetes cluster.

# Prerequisites

Currently the chart is made for a K3S kubernetes cluster with the integrated traefik ingress and currently I have no intention to develop this chart to a general purpose kubernetes cluster installation with other ingress controllers. Please let me know, if you feel the need, that this should be done.

# Installation

## Add traefik entry point

To expose your MQTT service to clients outside the cluster, you must add an entry point to the traefik ingress configuration.

To do this, you have to take the following manifest:

```
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    ports:
        mqtt:
            port: 1883
            expose: true
            protocol: TCP
```

And add it to the server installation. To do this:

1. Copy the file to the directory `/var/lib/rancher/k3s/server/manifests`
1. Restart the server, e.g. with `systemctl restart k3s.service`, on a systemd based system.

## Configure the chart

The chart comes with a decent set of default values for configuring the mosquitto image. See the comments in the default [Values file](./values.yaml) for further information or documentation of the configuration values below.

### Listener port

Sets the port, mosquitto listens on. This value is optional. If not set, the default port `1883` will be used.

Please have in mind that this setting impacts not only the port the pod is listening on, but also the service manifest and the ingress route created to expose the port outside the cluster. So if you are using another than the default port `1883`, please also adapt the trafik entry point accordingly.

```yaml
configuration:
    listener:
        port: 1883
```
### Listener address

The host interface/address/socket mosquitto listens on. This value is optional. If not set, mosquitto listens on all interfaces. See https://mosquitto.org/man/mosquitto-conf-5.html for further information.

```yaml
configuration:
    listener:
        address: "0.0.0.0"
```

### Enable persistence

With the default configuration, the mosquitto service does not use persistence. If you need to use the mosquitto MQTT broker with persistence, you can simply enable it.

Enabling persitence results in creating manifests for a `PersistentVolumeClaim` and mouting a volume matching the claim in the started pod.

```yaml
configuration:
    persistence:
        enabled: true
```

### Set the persistence volumes size

When using the mosquitto MQTT broker with persistence, you can either use the default size of the volume used to back the persitence database of `256Mi` or you can set the size with the volume size value.

```yaml
configuration:
    persistence:
        enabled: true
        size: 256Mi
```
