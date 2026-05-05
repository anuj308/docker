# Docker Tasks

This README contains the completed answers, commands, verification steps, and cleanup commands for the Docker PDF tasks.

## 1. Task 1 - Faulty Container Memory Crash

### Answers

- The missing or misconfigured container feature was a resource limit, especially the container memory limit.
- The Linux kernel mechanism that should have prevented this is cgroups, because cgroups control and limit CPU, memory, disk I/O, and other resource usage.
- No, namespaces alone would not solve this issue. Namespaces isolate what a container can see, but they do not limit how much memory it can consume.

## 2. Task 2 - Resource Isolation and Port Conflict

### Answers

- Cgroups prevent Container A from consuming all CPU by applying CPU limits or shares.
- The PID namespace ensures Container B cannot see processes running inside Container C.
- The network namespace allows all three containers to use port 80 internally because each container has its own isolated network stack.

## 3. Multiple Choice Questions - Image Registry

### Answers

1. B. To store and distribute container images
2. D. Tag
3. C. Private registry
4. C. Bridge between CI and CD

## 4. Task #1 - Ubuntu Container with Environment Variable

### Commands

```bash
docker run -it --name college_env -e COLLEGE=CSE ubuntu bash
echo $COLLEGE
exit
docker ps -a
docker stop college_env
docker ps -a
```

### Result

The command `echo $COLLEGE` prints `CSE` inside the container. After stopping the container, `docker ps -a` shows the container with status `Exited`.

### Cleanup

```bash
docker rm college_env
```

## 5. Practice Question - MongoDB Container with Port Mapping

### Command

```bash
docker run -d --name DB-app -p 80:8082 mongo
```

### Verification

```bash
docker ps
```

### Cleanup

```bash
docker stop DB-app
docker rm DB-app
```

### Note

The official MongoDB image is named `mongo` on Docker Hub. The command maps host port `80` to container port `8082` as requested.

## 6. Deployment Task - Simple Web Page with httpd

### Commands

```bash
docker run -d --name simple_web -p 8080:80 httpd
docker exec simple_web sh -c "echo '<h1>Welcome to Docker Web Deployment</h1>' > /usr/local/apache2/htdocs/index.html"
curl http://localhost:8080
```

### Expected Output

```html
<h1>Welcome to Docker Web Deployment</h1>
```

### Cleanup

```bash
docker stop simple_web
docker rm simple_web
```

## 7. Question 3 - docker run with Multiple Flags

### Command

```bash
docker run -it --name my_app -e APP_ENV=production -v /app/data:/data ubuntu bash
```

### Meaning

- `-it` starts the container in interactive terminal mode.
- `--name my_app` gives the container the name `my_app`.
- `-e APP_ENV=production` sets the environment variable.
- `-v /app/data:/data` bind mounts the local directory `/app/data` to `/data` inside the container.

### Cleanup

```bash
exit
docker rm my_app
```

## 8. Task - Container Interaction: File and Directory Management

### Start a Container

```bash
docker run -dit --name interaction_container ubuntu bash
```

### Create Directory and Files

```bash
docker exec interaction_container mkdir /project
docker exec interaction_container sh -c "echo 'This is our container interaction with our host machine.' > /project/report.txt"
docker exec interaction_container cat /project/report.txt
docker cp interaction_container:/project/report.txt ~/Desktop/report.txt
docker exec interaction_container sh -c "echo 'These are project notes.' > /project/notes.txt"
docker exec interaction_container ls -l /project
```

### Verification

The `cat` command verifies the content of `report.txt`. The `ls -l /project` command verifies that both `report.txt` and `notes.txt` exist inside `/project`.

### Cleanup

```bash
docker stop interaction_container
docker rm interaction_container
```

## 9. Three Practice Questions - Containers and Logs

### Question 1

Start an nginx container with the environment variable `ENV_MODE=production`.

```bash
docker run -d --name nginx_env -e ENV_MODE=production nginx
```

### Question 2

View logs for a running container named `my_app` and follow new entries in real time.

```bash
docker logs -f my_app
```

### Question 3

Start and stop a stopped container named `web_server`.

```bash
docker start web_server
docker stop web_server
```

## 10. Task - Docker Volume Data Persistence

### Commands

```bash
docker volume create projectdata
docker volume ls
docker volume inspect projectdata
docker run -dit --name project_container -v projectdata:/app/data ubuntu bash
docker exec project_container sh -c "echo 'This is my first volume.' > /app/data/report.txt"
docker stop project_container
docker rm project_container
docker run -dit --name project_container_new -v projectdata:/app/data ubuntu bash
docker exec project_container_new cat /app/data/report.txt
```

### Verified Output

```text
This is my first volume.
```

### Cleanup

```bash
docker stop project_container_new
docker rm project_container_new
```

## 11. Task 1 - University Portal Deployment with Docker

### Commands

```bash
docker volume create portaldata
docker run -d --name college_portal -p 8080:80 -e ENV=production -v portaldata:/usr/local/apache2/htdocs httpd
docker exec college_portal sh -c "echo '<h1>College Portal</h1><p>Environment: production</p>' > /usr/local/apache2/htdocs/index.html"
curl http://localhost:8080
docker logs college_portal
```

### Verified Output

```html
<h1>College Portal</h1><p>Environment: production</p>
```

### Cleanup

```bash
docker stop college_portal
docker rm college_portal
docker volume rm portaldata
```

## 12. Task 2 - Debugging a MySQL Container Failure

### Correct Command

```bash
docker run -d --name mysql_debug \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=college_db \
  -e MYSQL_USER=college_user \
  -e MYSQL_PASSWORD=college_pass \
  -p 3307:3306 \
  mysql:8
```

### Debug Commands

```bash
docker logs mysql_debug
docker exec -it mysql_debug mysql -u root -prootpass -e "SHOW DATABASES;"
```

### Cleanup

```bash
docker stop mysql_debug
docker rm mysql_debug
```
