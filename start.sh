#!/bin/bash

echo "-----------------------script starting-----------------------"

terraform init /home/student/terraform/terra/

echo "----------------------- ********** -----------------------"
terraform plan /home/student/terraform/terra/

echo "----------------------- ********** -----------------------"
terraform apply /home/student/terraform/terra/

echo "-----------------------wait & run helm install-----------------------"

sleep 10 && helm install app /home/student/kubernetes/task/ &

sleep 15 && echo "-----------------------script finished-----------------------"

sleep 20 &

shift
