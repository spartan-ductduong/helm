# Chargefuze chart

Provide a simple way to deploy applications base on our demand

## Introduction

This chart bootstraps a [charge-fuze](https://github.com/charge-fuze/infra-helm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+

## Get Repo Info

```bash
# Add the Elastic Helm Repository
helm repo add chargefuze https://<your-token>@raw.githubusercontent.com/charge-fuze/infra-helm/master/hosting
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chargefuze chart using Helm.

```sh
helm install <release_name> chargefuze/<chart_name> -n <namespace> --create-namespace
```

`<release_name>`: The name assigned to a release when install a Helm chart.

## Upgrading the Chart

To upgrade the chargefuze chart using Helm.

```sh
helm upgrade <release_name> [--install] chargefuze/<chart_name> -n <namespace> -f /values.yaml
```

`/values.yaml`: Points to a specific values file (values.yaml) that contains configuration settings for the Helm chart.

`--install`: Tell Helm to install the chart if the specified release does not exist.

## Uninstalling the Chart

To uninstall/delete the `<release_name>` deployment from the `<namespace>`:

```console
# Uninstalling the chargefuze chart
helm delete <release_name> -n <namespace>
```
The command removes all the resources associated with the chart and deletes the release.

## Running helm check

To render templates with provided values:

```console
helm template --values ./test/values.yaml ./charts/chargefuze
```
The command allows to prevalidate helm chart template before its deployment and executes helm lint and helm template commands

## Validating helm template

To test rendering chart templates locally.
```
helm template --dry-run --debug ./charts/chargefuze --generate-name

```

```
helm template <version>.tgz --namespace <namespace> -f "values.yaml" > template-file.yaml
```

- Example:

```
cd /charts/chargefuze/
helm package .
helm template chargefuze-0.1.4.tgz --namespace dev -f "values.yaml" > template-file.yaml

This command will gen template-file.yaml file at /charts/chargefuze/
```

## Configuration

The following table lists the configurable parameters of the chargefuze chart and their default values.

| Parameter                                     | Description                                                                                  | Default      |
|-----------------------------------------------|----------------------------------------------------------------------------------------------|--------------|
| podAnnotations                                | Pods annotations                                                                             | {}           |
| image.repository                              | Container image repository                                                                   | nginx        |
| image.tag                                     | Container image tag                                                                          | null         |
| image.pullPolicy                              | Container image pull policy                                                                  | IfNotPresent |
| imagePullSecrets                              | Global Docker registry secret names as an array                                              | []           |
| fullnameOverride                              | String to fully override chargefuze.fullname template                                        | null         |
| nameOverride                                  | String to partially override common.names.fullname template (will maintain the release name) | null         |
| ingress.enabled                               | Enable ingress controller resource                                                           | false        |
| ingress.className                             | Ingress class name (Kubernetes 1.18+)                                                        | null         |
| ingress.hosts                                 | Ingress resource hostnames                                                                   | {}           |
| ingress.annotations                           | Ingress annotations configuration                                                            | {}           |
| ingress.tls                                   | Ingress TLS configuration                                                                    | []           |
| livenessProbe                                 | Liveness Probe initial delay and timeout                                                     | {}           |
| readinessProbe                                | Readiness Probe initial delay and timeout                                                    | {}           |
| startupProbe                                  | Startup Probe initial delay and timeout                                                      | {}           |
| service.port                                  | Name for service port                                                                        | 80           |
| service.type                                  | ClusterIP, NodePort, or LoadBalancer                                                         | ClusterIP    |
| service.name                                  | Service name                                                                                 | http         |
| service.protocol                              | Service protocol                                                                             | tcp          |
| containerPort                                 | Service target Port                                                                          | 8080         |
| serviceAccount.create                         | Specifies whether a service account should be created                                        | false        |
| serviceAccount.annotations                    | Annotations to add to the service account                                                    | {}           |
| serviceAccount.name                           | The name of the service account to use                                                       | null         |
| replicaCount                                  | Number of replicas                                                                           | 1            |
| resources                                     | Server resource requests and limits                                                          | {}           |
| nodeSelector                                  | Node labels for pod assignment                                                               | {}           |
| securityContext                               | Custom security context for chargefuze container                                             | {}           |
| podSecurityContext                            | Custom pod security context for chargefuze pod                                               | {}           |
| tolerations                                   | Toleration labels for pod assignment                                                         | []           |
| affinity                                      | Affinity settings for pod assignment                                                         | {}           |
| autoscaling.enabled                           | Enables Autoscaling                                                                          | false        |
| autoscaling.minReplicas                       | Minimum amount of Replicas                                                                   | 1            |
| autoscaling.maxReplicas                       | Maximum amount of Replicas                                                                   | 100          |
| autoscaling.targetCPUUtilizationPercentage    | Target CPU Utilization in percentage                                                         | 80           |
| autoscaling.targetMemoryUtilizationPercentage | Target Memory Utilization in percentage                                                      | 80           |
| configMap.asFile.enabled                      | Determines if the ConfigMap should be created from files                                     | false        |
| configMap.asFile.data                         | Specifies the data for the ConfigMap created from files                                      | {}           |
| configMap.asEnv.enabled                       | Enables creating a ConfigMap from environment variables                                      | false        |
| configMap.asEnv.data                          | Specifies the data for the ConfigMap created from environment variables                      | {}           |
| configMap.asFile.mountPath                    | Specifies the path to mount files for the ConfigMap                                          | {}           |
| secret.asFile.enabled                         | Determines if the Secret should be created from files                                        | false        |
| secret.asFile.data                            | Specifies the data for the Secret created from files                                         | {}           |
| secret.asEnv.enabled                          | Enables creating a Secret from environment variables                                         | false        |
| secret.asEnv.data                             | Specifies the data for the Secret created from environment variables                         | {}           |
| hooks                                         | Allows customization of various aspects of the Job                                           | {}           |
| workers                                       | Enables users to deploy scalable and customizable worker components                          | {}           |
| [backendConfig](https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-configuration#configuring_ingress_features_through_frontendconfig_parameters) | Specifies the configuration for backend configuration of ALB of GKE ingress                  | {}           |
| [frontendConfig](https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-configuration#configuring_ingress_features_through_backendconfig_parameters) | Specifies the configuration for frontend configuration of ALB of GKE ingress                 | {}           |
| [managedCertificate](https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs)                                                                   | Enable the managed certificate for TLS/SSL for GKE ingress ALB                               | {}           |
The above parameters map to the env variables defined in [chargefuze](https://github.com/charge-fuze/infra-helm).

