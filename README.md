# Test Task


### step 1: Create connect to AWS

### AWS EKS cluster with Terraform

In your own console, create a ~/.aws/credentials file and put your credentials in it:

<br>

```
[default]
 aws_access_key_id=***********
 aws_secret_access_key=****************************

```

<br>


The next step is to create config file:

<br>

```
[default]
 region=eu-central-1

```

<br>

### Step 2: create provider.tf

I specify here to Terraform that we want to use an AWS provider. Also have to precise in which region you will deploy it and which configuration you will use.

<br>

```
provider "aws" {
   profile    = "default"
   region     = "eu-central-1"
 }

```
<br>

### Step 3: created resources what I needed

This EKS will be deployed in the default VPC of my account.
First, I check in my AWS console, the subnet of the default VPC.
<br>

Created this file ![eks.tf](https://github.com/Reward2020/TestTask/blob/master/terra/eks.tf)

<br>

### Step 4: Add output.tf

I created a file outputs.tf. Here we have the endpoint of EKS and his certificate.

<br>

```
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.aws_eks.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.aws_eks.certificate_authority 
}

```

<br>

### Step 5: Deploy my resources

Terraform init: I used to initialize a working directory containing Terraform configuration files.

Terraform plan: I used to check the changes of the configuration.

Terraform apply: to the changes required state of the configuration.


### K8s - Create & Manage - Helm Charts

<br>

Created a skill for deploying infrastructure load balancer and K8s

<br>

The templates folder contains the files: deployment.yaml, service.yaml.
Files in task folders: Chart.yaml, values.yaml

<br>
The Chart.yaml file contains technical information on the application.

```
apiVersion: v2
name : App-Chart
description: My Helm Cart for Kube
type: application
version: 0.1.1
appVersion: 1.0.2

keywords:
   - apache
   - http
   - https
   - testtask

maintainers:
    - name : Anatoliy

```

<br>

The values.yaml file contains the default values for application.

<br>

```
containet:
   image: gas/k8sphp:latest

replicaCount: 2

```

<br>
Created for the ability to add variables for the required values.

<br>
deployment.yaml

<br>

```
apiVersion : apps/v1
kind       : Deployment

metadata:
     name : {{ .Release.Name }}-deployment
     labels : 
        app: {{ .Release.Name }}-deployment
spec:
      replicas: {{ .Values.replicaCount }}
      selector:
          matchLabels:
              project: {{ .Release.Name }}
      template:
           metadata:
               labels:
                  project: {{ .Release.Name }}
           spec: 
               containers:
                   - name: {{ .Release.Name }}-web
                     image: {{ .Values.container.image }}
                     ports:
                        containerPort: 80

```

<br>

Release.Name is taken from the name that we indicate when deploying our application.

<br>

service.yaml


```

apiVersion : v1
kind       : Service

metadata:
     name : {{ .Release.Name }}-deployment
     labels : 
        env: prod
        owner: Anatoliy
spec:
   selector:
      project: {{ .Release.Name }}
   ports:
     - name: {{ .Release.Name }}-list
       protocol : TCP0
       port: 80
       targetPort: 80
   type: LoaderBalancer
   
```
<br>

To deploy the application, I used the following commands:

```
helm install app task/ # application deployment starts
```
<br>

```
helm list # checking the status of the application
```

<br>

```
kubectl get pods # checking count running pods
```

<br>

```
kubectl get svc # checking the condition of the load balancer
```

<br>

```
helm delete app # removed the app with all dependencies
```