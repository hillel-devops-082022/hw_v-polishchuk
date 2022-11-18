# Home works by student V.Polishckuk

----

### HW #15. Git and GitHub practice
- Init repository
- Create and commit file
- Create revert commit
- Work with **.gitignore**
- Work with branches (merge and rebase)
- Add remote repository

### HW #16. Docker
- Build two images from sources (frontend, backend)
- Work with dockerhub
- Run containers from this images
- Tie containers (frontend, backend, mongodb) in one application without docker composer (names, ports, network, env variables)
    ```
    docker run --rm --name mongo --expose 27017 --network=app mongo:2.2
    docker run --rm --name backend -p 8080:8080 --network=app --env PORT="8080" --env NODE_ENV="production" --env MONGO_DB_URI="mongodb://mongo:27017/conduit" polishchukv/hillel-backend:0.0.1
    docker run --rm --name frontend -p 80:80 --network=app polishchukv/hillel-frontend:0.0.1
    ```