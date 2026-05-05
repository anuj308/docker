# Docker Tasks

This README contains the completed answers, commands, verification steps, and cleanup commands for the Docker PDF tasks.

## 1. Task 1 - Faulty Container Memory Crash

### Answers

- The missing or misconfigured container feature was a resource limit, especially the container memory limit.
- The Linux kernel mechanism that should have prevented this is cgroups, because cgroups control and limit CPU, memory, disk I/O, and other resource usage.
- No, namespaces alone would not solve this issue. Namespaces isolate what a container can see, but they do not limit how much memory it can consume.

