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
