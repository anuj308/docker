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
