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