## Automatic AuthZ through with Envoy and OPA

This demo showcases how to configure Envoy and OPA to automatically authorize requests based on traffic patterns seen from Pixie's protocol tracing data.

### Prerequisites
- `kubectl` installed
- K8s cluster with Pixie installed and `px` cli installed. Follow the instructions [here](https://docs.px.dev/installing-pixie/install-schemes/cli/).
- AWS account with an S3 bucket and access key and secret key with permissions to read and write to the bucket.


### Deployment
1. Update OTel Collector configuration with S3 bucket details and add credential files used by `kustomize`
- Add the AWS access key and secret key to the envoy-opa/otel-collector/{AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY} files and to your `~/.aws/credentials` file. Note: Make sure your credentials files 
- S3 bucket details modified in `envoy-opa/otel-collector/otel-collector-config.yaml`. Search for the `PLACEHOLDER` comment for the locations to modify.

2. Clone the repo and change the OPA bundle location in envoy-opa/kustomization.yaml to your fork

3. Deploy the application
```bash
$ ./deploy-spire-and-demo-applications.sh
```
