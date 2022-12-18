# Home works by student V.Polishckuk

----

### HW #15. Git and GitHub practice
- Init repository
- Create and commit file
- Create revert commit
- Work with **.gitignore**
- Work with branches (merge and rebase)
- Add remote repository

### HW #16. Docker. Docker composer
- Build two images from sources (frontend, backend)
- Work with dockerhub
- Run containers from this images
- Tie containers (frontend, backend, mongodb) in one application without docker composer (names, ports, network, env variables)
    ```
    docker run --rm --name mongo --expose 27017 --network=app mongo:2.2
    docker run --rm --name backend -p 8080:8080 --network=app --env PORT="8080" --env NODE_ENV="production" --env MONGO_DB_URI="mongodb://mongo:27017/conduit" polishchukv/hillel-backend:0.0.1
    docker run --rm --name frontend -p 80:80 --network=app polishchukv/hillel-frontend:0.0.1
    ```
- Work with **docker compose**. Run application from one file
  `docker compose up -d`
- Combine several docker compose file and run them at once

### HW #17. Docker Swarm
- Make backend dependable from db
- Create and deploy Docker Swarm service (from **hw_16** folder!)
  ````
  docker swarm init
  docker stack deploy -c docker-compose.yml -c docker-compose.stack.yml realworld
  ````
  
### HW #18. AWS CLI
- Work with basic AWS object via CLI
- Create and destroy simple structure for private and public instances
- `start1.txt` and `stop1.txt` - listing for the first part of the task
- `start2.txt` and `stop2.txt` - listing for the second part of the task

### HW #19. Terraform
- Get terraform code for creating AWS VPC, private and public subnets, security groups
- Init, validate, run and destroy AWS resources.
  ````
  terraform init
  terraform plan
  terraform apply
  terraform state list
  terraform destroy
  ````
  
### HW #20. Terraform modules
- Work with terraform-aws-vpc, terraform-aws-security-group and terraform-aws-ec2-instance modules
- Build project with creating VPC, 2 subnets (private and public), 3 security groups (http, https, ssh) and variable amount of instances (private and public).
- Empty Public IP for private instances in output just illustrates that they haven't public IP.

### HW #21. Ansible intro
- Build AWS infrastructure with terraform (2 instances, load balancer and security group)
- Create Python virtual environment with pipenv (config this environment with .env file, install ansible)
- Provision created instances with Ansible (install python and nginx)

To run code:
- Set terraform variables (region and access settings)
- Create `.env` file from `env_sample`. Fill it with valid credentials
- In `ansible/ansible.cfg` file set path to `key.pem` file, which must match path from terraform variable
- Run code with:
  ````bash
  terraform init && terraform apply # create AWS infrastructure
  pipenv sync && pipenv shell # enter virtual environment
  cd ansible ; ansible-playbook --limit tag_Project_realworld playbook.yml # provision instances
  ```` 
  
You can check it by domain form terraform output.
To destroy your code:
- Exit from the virtual environment (if you're still there) with `exit`
- `terraform destroy` to destroy AWS infrastructure

### HW #22. Ansible: Vault, Handlers, Vagrant, Templates
- Work with Ansible vault, handlers, templates
- Use Ansible as Vagrant provisioner
- Use Ansible tags for tasks, to run separate tasks from playbook
- Work with Ansible-lint
- Run code with:
````bash
  terraform init && terraform apply # create AWS infrastructure
  pipenv sync && pipenv shell # enter virtual environment
  cd ansible ; ansible-playbook --limit tag_Project_realworld playbook.yml --ask-vault-pass # provision instances
```` 
- Steps to stop code the same as in **HW #21**

### HW23. Ansible: Roles, Molecule
- Create new ansible role
- Test it with molecule on virtual machine (vagrant + virtualbox)
- Replace old playbook tasks with role usage
- Run tests with:
````bash
  cd terraform # enter project root
  pipenv sync && pipenv shell # enter virtual environment
  cd ansible/roles/nginx # go to the role directory
  molecule test # run all test on this role
````
- Run and stop project the same as **HW22**


### HW24. Kubernetes. Realworld app
- Work with StorageClass, PersistentVolumesClaims, PersistentVolumes
- Work with Deployments, StatefulSets
- Work with Services, Ingress

#### Run code:
- Start minikube cluster
  ````bash
  minikube start -p first-cluster # start cluster
  minikube addons enable csi-hostpath-driver -p first-cluster # enable csi StorageClass
  minikube addons enable ingress -p first-cluster # enable ingress Controller
  ````
- Add DNS records to hosts file
  ````bash
  echo "$(minikube ip -p first-cluster) realworld.local.io" | sudo tee -a /etc/hosts # frontend
  echo "$(minikube ip -p first-cluster) backend.realworld.local.io" | sudo tee -a /etc/hosts # backend 
  echo "$(minikube ip -p first-cluster) adminmongo.realworld.local.io" | sudo tee -a /etc/hosts # adminmongo
  ````
- Set first-cluster as default for kubectl
  ````bash
  kubectl config use-context first-cluster # set first-cluster as default
  ````
- Deploy mongoDB
  ````bash
  kubectl apply -f k8s/mongodb/pvc_mongo.yml # create PersistentVolumesClaims for future mongodb pods
  kubectl apply -f k8s/mongodb/statefulset_mongo.yml # deploy mongodb
  kubectl apply -f k8s/mongodb/svc_mongo.yml # create service for mongodb
  ````
- Deploy backend
  ````bash
  kubectl apply -f k8s/backend/deployment-backend.yml # deploy backend
  kubectl apply -f k8s/backend/svc_backend.yml # create service for backend
  kubectl apply -f k8s/backend/ingress_backend.yml # create ingress for backend to make it reachable from the outside of cluster
  ````
- Deploy frontend
  ````bash
  kubectl apply -f k8s/frontend/deployment-frontend.yml # deploy frontend
  kubectl apply -f k8s/frontend/svc_frontend.yml # create service for frontend
  kubectl apply -f k8s/frontend/ingress_frontend.yml # create ingress for frontend to make it reachable from the outside of cluster
  ````
- Deploy mongo-admin
  ````bash
  kubectl apply -f k8s/mongo_admin/statefulset_mongo_admin.yml # deploy mongo_admin
  kubectl apply -f k8s/mongo_admin/svc_mongo_admin.yml # create service for mongo_admin
  kubectl apply -f k8s/mongo_admin/ingress_mongo_admin.yml # create ingress for mongo_admin to make it reachable from the outside of cluster
  ````

#### Stop code:
- Remove all created resources
  ````bash
  kubectl delete -f k8s/mongo_admin
  kubectl delete -f k8s/frontend
  kubectl delete -f k8s/backend
  kubectl delete -f k8s/mongodb
  ````
- Remove DNS-records from hosts file
  ````bash
  sudo sed -i -E "/$(minikube ip -p first-cluster) (backend.|adminmongo.)?realworld.local.io/d" /etc/hosts
  ````
- Delete cluster
  ````bash
  minikube delete -p first-cluster
  ````