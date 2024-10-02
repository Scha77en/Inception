

### How Docker and docker compose work

### **Docker**

Docker is a platform that enables you to package, deploy, and run applications in isolated environments called **containers**. Containers allow you to encapsulate an application along with all its dependencies, libraries, and configuration files, ensuring that it runs the same way regardless of where it is deployed.

#### **Key Concepts:**

- **Images:** A Docker image is a lightweight, standalone package that includes everything needed to run a piece of software, including the code, runtime, libraries, environment variables, and configuration files. You can think of it as a snapshot of your application.
- **Containers:** A container is a running instance of a Docker image. It is an isolated environment that runs your application, similar to a lightweight virtual machine but more efficient and portable.
- **Dockerfile:** This is a text file that contains instructions on how to build a Docker image. It typically specifies the base image, dependencies, environment variables, and the commands needed to run the application.
- **Registry (e.g., Docker Hub):** A registry stores Docker images. You can pull images from registries or push your own images to them.

#### **How Docker Works:**

1. **Create an Image:** You define how to build your application in a `Dockerfile` and then build the image using the command `docker build`.
2. **Run a Container:** Once you have an image, you can start a container with `docker run`. The container will execute the application inside the isolated environment.
3. **Manage Containers:** Docker provides commands to stop, restart, and remove containers (`docker stop`, `docker restart`, `docker rm`), allowing easy management of application lifecycles.

### **Docker Compose**

Docker Compose is a tool for defining and running multi-container Docker applications. It allows you to manage complex systems with multiple services (e.g., a web server, database, etc.) by defining them in a single YAML file (`docker-compose.yml`).

#### **Key Concepts:**

- **Services:** In Docker Compose, a service refers to a container that runs a part of your application (e.g., a database service, a web service). Each service is defined in the `docker-compose.yml` file.
- **Volumes:** You can persist data by using Docker volumes, ensuring that data inside containers (like databases) isn't lost when the container stops.
- **Networks:** Docker Compose creates networks for containers to communicate with each other. Containers in the same network can discover and talk to each other using service names.

#### **How Docker Compose Works:**

1. **Define Services:** You write a `docker-compose.yml` file that specifies all the services required for your application, including the Docker images to use, ports to expose, volumes to mount, and networks to connect.
2. **Bring Up Services:** You run `docker-compose up`, and Docker Compose will start all the services defined in the YAML file. Each service will run as a separate container.
3. **Manage Services:** You can use `docker-compose down` to stop and remove containers, networks, and volumes created by `docker-compose up`. Other commands like `docker-compose stop`, `docker-compose restart`, and `docker-compose logs` help manage the running services.

---

Both Docker and Docker Compose help streamline the development, deployment, and management of applications by packaging them in containers, ensuring consistency across different environments.




### The difference between a Docker image used with docker compose and without docker compose

The primary difference between a Docker image used **with** Docker Compose and **without** Docker Compose is the **way** the image is managed and orchestrated, not the image itself. Docker Compose is a tool for running multi-container Docker applications, but the underlying images are the same in both cases.

### **Docker Image Without Docker Compose**

When using Docker without Compose, you interact with Docker images and containers manually through the Docker CLI (`docker` command). You have to explicitly run each container individually and configure options like networks, ports, volumes, and environment variables using command-line flags.

#### **How it works:**

1. **Pull or build an image:** You either pull an existing image from a registry or build your own image using a Dockerfile (`docker build`).
    
2. **Run the container manually:** You run the image with `docker run`, specifying the necessary configurations:

```bash
docker run -d -p 8080:80 --name web nginx
```

1. This command starts a container from the `nginx` image, exposing port 80 inside the container on port 8080 on the host.
    
2. **Manually manage networking and volumes:** If your application requires a database, you need to manually link the containers, create a custom network, and manage persistent storage (volumes) with additional `docker network` and `docker volume` commands.
    

#### **Pros:**

- Fine-grained control over individual containers.
- Suitable for single-container applications or manual management of small setups.

#### **Cons:**

- Becomes cumbersome and complex to manage when dealing with multiple containers and services.
- Manually setting up networks, linking containers, and configuring dependencies is error-prone and time-consuming.

### **Docker Image With Docker Compose**

When using Docker Compose, you still use the **same Docker images**, but the management and orchestration of multiple containers are done automatically based on the configuration defined in a `docker-compose.yml` file.

#### **How it works:**

1. **Define services in a YAML file:** In Docker Compose, each container is treated as a **service**. You define these services (each corresponding to a Docker image) in a `docker-compose.yml` file along with networking, volumes, environment variables, and other configuration options.

```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  db:
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: password
```

2. **Run all services with a single command:** You use `docker-compose up` to start all the containers specified in the `docker-compose.yml` file. Compose takes care of networking, dependencies, and service configurations automatically.
```bash
docker-compose up
```

3. **Automatic network and volume management:** Docker Compose automatically sets up a **network** for the services to communicate and handles the creation of persistent **volumes** for data storage. You don't need to manually link containers or create networks.

#### **Pros:**

- **Easier orchestration** of multi-container applications (e.g., web server + database).
- Automatically manages networks, volumes, and dependencies.
- Simplifies defining and running complex setups with multiple containers.
- **Single command** to bring up/down all related services (`docker-compose up` / `docker-compose down`).

#### **Cons:**

- May be overkill for simple, single-container applications.
- Requires a `docker-compose.yml` file, which adds an additional layer of setup.

### **Key Differences:**

|**Aspect**|**Without Docker Compose**|**With Docker Compose**|
|---|---|---|
|**Execution**|Manually run with `docker run`.|Automatically runs via `docker-compose up`.|
|**Configuration**|CLI flags for each container setup.|Centralized `docker-compose.yml` file.|
|**Networking**|Manually configure networks or link containers.|Automatic network creation between services.|
|**Volume Management**|Manually manage volumes with `docker volume`.|Automatically handled by Compose.|
|**Complexity**|Higher for multi-container apps.|Simpler, as services are defined and run together.|
|**Best Use Case**|Simple, single-container apps.|Multi-container apps with multiple dependencies.|

In short, **Docker Compose** is an orchestration tool for managing and running multi-container Docker applications easily, while **Docker alone** requires more manual work to configure and run each container. The **images themselves are the same**, but Docker Compose simplifies the process, especially for complex setups.

### The benefit of Docker compared to VMs

Docker offers several benefits over traditional virtual machines (VMs):

- **Lightweight**: Containers share the host OS kernel, making them faster to start and requiring fewer resources compared to VMs, which need a full OS for each instance.
- **Faster Boot Time**: Containers launch in seconds, while VMs take longer to boot as they start a complete OS.
- **Efficiency**: Containers use less memory and CPU since they don’t need to run a separate OS.
- **Portability**: Docker containers are consistent across environments (development, testing, production), reducing compatibility issues.
- **Scalability**: Easier to scale applications by running multiple container instances with minimal overhead.

In summary, Docker is more resource-efficient, portable, and faster compared to VMs, making it ideal for modern application development and deployment.


### then why some still use VMs if docker is more efficient than VMs ?

Despite Docker's efficiency, **virtual machines (VMs)** are still used in certain scenarios where they offer advantages Docker can't fully provide:

1. **Full Isolation**: VMs provide complete isolation with their own OS, which is more secure for running untrusted or heavily isolated workloads. Containers share the host OS kernel, making them more prone to kernel-level vulnerabilities.
    
2. **Compatibility with Multiple OSes**: VMs can run entirely different operating systems on the same host (e.g., Windows on a Linux host), while Docker containers rely on the host's OS kernel, limiting cross-OS use.
    
3. **Legacy Applications**: Some older applications aren’t designed to run in containers and require a full OS environment, making VMs a better fit.
    
4. **Better Resource Allocation Control**: VMs offer more granular control over CPU, memory, and other resources, making them preferable for workloads with strict resource management requirements.
    
5. **Mature Management Tools**: VMs have more established management, monitoring, and orchestration tools in large-scale enterprise environments.
    

In short, VMs are still used for situations that require stronger isolation, OS flexibility, or compatibility with legacy systems.


### the pertinence of the directory structure required for this project.

#### **Why This Structure is Important:**

- **Modularity:** Each service has its own folder, making it easier to maintain and update without affecting others.
- **Separation of Concerns:** Files like `Dockerfile`, configuration files, and environment variables are organized logically, so different components (web server, database, etc.) are managed in isolation.
- **Scalability:** If you need to add new services in the future (e.g., Redis, or a backup service), you can easily create a new folder under `requirements`.
- **Automation:** The `Makefile` and Docker Compose file ensure the project can be started and managed with simple commands, making deployment smoother and faster.

This structure mirrors best practices in containerized environments, ensuring that your project is clean, organized, and easy to scale or maintain.


### what is an SSL/TLS certificate ?

An **SSL/TLS certificate** is a digital certificate used to establish a secure, encrypted connection between a web server and a user's browser. It ensures that data transmitted between the two remains private and secure, which is particularly important for sensitive information like passwords, credit card numbers, and personal data.

### Key Components of an SSL/TLS Certificate:

1. **Public and Private Keys**:
    
    - **Public key**: Embedded in the SSL/TLS certificate and shared with clients (browsers).
    - **Private key**: Kept secret by the web server. It's used to decrypt data encrypted with the public key.
2. **Certificate Authority (CA)**:
    
    - A **Certificate Authority (CA)** is a trusted entity that issues SSL/TLS certificates. It verifies the identity of the website owner before issuing a certificate, ensuring trust between users and the website.
3. **Encryption**:
    
    - SSL/TLS certificates use encryption protocols (**SSL** is older; **TLS** is the modern standard) to scramble data in transit. Only the intended recipient can decrypt and read the data.

### Types of SSL/TLS Certificates:

- **Domain Validated (DV)**: Basic validation, ensuring the domain is controlled by the certificate requester.
- **Organization Validated (OV)**: Verifies both domain ownership and the organization’s identity.
- **Extended Validation (EV)**: The highest level of validation, confirming the organization's legal existence and more.

### Benefits of SSL/TLS Certificates:

- **Data Encryption**: Prevents eavesdropping and tampering.
- **Authentication**: Verifies the identity of the website owner, protecting against phishing.
- **Trust**: Web browsers display a padlock or "https://" in the URL bar, signaling to users that the site is secure.

### In Summary:

An SSL/TLS certificate is vital for secure online communication, encrypting data exchanged between servers and users, and building trust through authentication.


### Why the nginx redirect the http request into an https one even tho i am not explicitly declaring it.


### a simple explanation of docker-network

Docker networks allow containers to communicate with each other and with the outside world. Here's a simple breakdown:

### Key Concepts

1. **Isolation**: Each Docker network isolates its containers, meaning that containers on different networks cannot communicate with each other unless you explicitly connect them.
    
2. **Communication**: Containers within the same network can communicate with each other using their container names as hostnames. For example, if you have two containers named `web` and `db` in the same network, the `web` container can connect to the `db` container simply by using `db` as the hostname.
    
3. **Types of Networks**:
    
    - **Bridge Network**: The default network type. It's used for standalone containers and allows them to communicate with each other.
    - **Host Network**: Containers share the host's network stack and can directly access the host's network interfaces. This can improve performance but reduces isolation.
    - **Overlay Network**: Used for multi-host networking, allowing containers on different Docker hosts to communicate securely. Useful for clustering and orchestration tools like Docker Swarm.
    - **None Network**: Containers are completely isolated from all networks, not assigned any IP address.
4. **Networking Commands**: You can create, inspect, and manage Docker networks using commands like:
    
    - `docker network create <network_name>`: Creates a new network.
    - `docker network ls`: Lists all Docker networks.
    - `docker network inspect <network_name>`: Shows detailed information about a specific network.

### Summary

Docker networks provide a flexible way to manage container communication and isolation, enabling you to structure your applications as needed while maintaining security and efficiency.


### Try to access the service via http (port 80) and verify that you cannot connect.

The service my be configured to redirect http port 80 requests to https port 443 in the configuration file. if not and the service still redirect it may be because of the browser caching or an **HSTS (HTTP Strict Transport Security)** header, the browser would remember to always use HTTPS for the domain.

if the redirection is happening in your browser and want to check that the http is not listening you can check the configuration file of the nginx or use the following command :

```bash
curl -I http://localhost
``` 

you should see something like :
```bash
curl: (7) Failed to connect to localhost port 80 after 0 ms: Couldn't connect to server
```

and to check that you can connect with https you can use :

```bash
curl -Ik https://localhost
```

the `-k` flag is used to ignore the certification warning when used without providing a cert.

or else if you want to use the cert to verify you can use the following command :

access your nginx container bash and get the nginx-selfsigned.crt certificate :

accessing the nginx container bash :
```bash
docker exec -it nginx bash
```

cat this file :

```bash
cat /etc/ssl/certs/nginx-selfsigned.crt
```

copy the cert text and save it in a file locally and then use :

```bash
curl --cacert /path/to/your-cert/nginx-selfsigned.crt -I https://login.42.fr
```

replace login with your actual login.

you should see something like this if the connection was successful :

```bash
HTTP/1.1 200 OK
Server: nginx/1.18.0
Date: Sat, 28 Sep 2024 19:58:02 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
Link: <https://localhost/index.php?rest_route=/>; rel="https://api.w.org/"
```


a good read [TLS Certificate Verification](https://curl.se/docs/sslcerts.html)

### How to log into the database ?

to log into the database use the command :

```bash
docker exec -it mariadb mysql -u root -p<root-password>
```

after login u can check the databases using :

```mariadb
show databases;
```

you can use a certain data base using :

```mariadb
use wordpress;
```

you can show the tables of that database using :

```mariadb
show tables;
```

and you can inspect data in the table using :

```mariadb
select * from wp_users;
```

exit using :

```mariadb
exit;
```





### **NAMESPACES :**

Namespaces in containers are a fundamental feature of the Linux kernel that provide isolation for various system resources. They allow multiple instances of the same resource (like processes, network interfaces, and file systems) to run simultaneously in separate environments without interfering with each other. This is crucial for containerization, as it helps ensure that containers are isolated from the host system and from each other.

Here are the main types of namespaces commonly used in containers:

1. **Process Namespace (`pid`)**:
    
    - Isolates the process IDs (PIDs) so that processes in one namespace can’t see processes in another namespace. Each container can have its own set of PIDs, enabling processes to run with the same PID numbers in different containers.
2. **Network Namespace (`net`)**:
    
    - Provides isolation for network interfaces, IP addresses, ports, and routing tables. Each container can have its own network stack, allowing it to have its own network interfaces and IP addresses separate from the host and other containers.
3. **Mount Namespace (`mnt`)**:
    
    - Isolates the file system mount points. This means that changes to the file system structure in one container do not affect others. Each container can have its own view of the file system hierarchy.
4. **User Namespace (`user`)**:
    
    - Isolates user and group IDs. This allows a container to run as a non-root user while still having root privileges within the container, enhancing security.
5. **IPC Namespace (`ipc`)**:
    
    - Isolates inter-process communication (IPC) resources such as message queues, semaphores, and shared memory. This prevents processes in one container from communicating with processes in another.
6. **UTS Namespace (`uts`)**:
    
    - Isolates the hostname and domain name. Each container can have its own hostname and domain name that are different from the host and other containers.
7. **Cgroup Namespace (`cgroup`)**:
    
    - Isolates the cgroup settings, which control resource allocation (CPU, memory, etc.). Each container can have its own resource limits and control groups.

### Benefits of Using Namespaces

- **Isolation**: Ensures that processes, networking, and file systems are independent across containers, providing security and stability.
- **Resource Management**: Allows for effective resource allocation and limits within containers.
- **Simplified Management**: Makes it easier to manage multiple applications or services without conflicts.

Namespaces are a key technology behind containers, enabling lightweight, isolated environments that can run concurrently on the same host.


Examples of Namespaces used our project :

1. **Process Namespace**: Each container (like your Nginx, MariaDB, and WordPress containers) runs in its own process namespace. This means that the processes within each container are isolated from those in other containers and from the host system. For example, the processes in the WordPress container won't interfere with those in the MariaDB container.
    
2. **Network Namespace**: Each container can have its own network namespace. This allows you to configure the Nginx container to listen on specific ports (like 443 for SSL) while the MariaDB container listens on port 3306, without conflicts. The containers can communicate over a virtual network defined by your Docker setup.
    
3. **Mount Namespace**: The file systems of your containers are isolated from each other. For instance, the WordPress container can have its own file system structure separate from the MariaDB container, even if they share the same host.
    
4. **User Namespace**: If you configured user namespaces (though it's not explicitly shown in your Docker setup), each container could run processes as non-root users while still having root access inside the container.
    
5. **IPC Namespace**: If your containers needed to communicate via IPC mechanisms, they would do so within their own namespace, preventing interference from other containers.
    
6. **UTS Namespace**: Each container can have its own hostname (e.g., a unique name for your WordPress container), allowing for better identification and management.
    

Overall, Docker abstracts these namespaces for you, but they are indeed a fundamental part of how your containers operate, providing isolation and security for your applications.


### **What are Cgroups :**

Control groups (Cgroups) are a Linux kernel feature that allows you to allocate and limit system resources (such as CPU, memory, disk I/O, and network bandwidth) for a group of processes. They are crucial for resource management and isolation in containerization. Here’s a brief overview of key aspects:

1. **Resource Limiting**: Cgroups can set limits on the amount of CPU and memory that a group of processes can use. This prevents any single process from consuming all resources, ensuring fair usage.
    
2. **Resource Accounting**: Cgroups track resource usage for each group of processes, allowing administrators to monitor how much CPU, memory, and I/O a specific application or service is consuming.
    
3. **Prioritization**: Cgroups enable the prioritization of processes by adjusting their access to CPU and memory. This is useful for ensuring critical applications receive the resources they need to function properly.
    
4. **Isolation**: By combining Cgroups with namespaces, containers can be isolated not just in terms of process execution but also resource usage, ensuring that one container doesn’t affect the performance of another.
    
5. **Dynamic Control**: Cgroups allow you to adjust resource limits on the fly. For example, if a container is consuming too much memory, you can lower its limit without restarting it.
    

In the context of Docker and other containerization technologies, Cgroups play a vital role in ensuring that containers operate efficiently and without interfering with each other or the host system.

#### **Cgroups management :**

In Docker, control groups (Cgroups) are primarily managed by Docker itself, but you can also configure them according to your needs. Here’s how it works:

1. **Managed by Docker**: When you run a container, Docker automatically creates and manages the Cgroups for that container. It sets resource limits and allocates resources based on the configuration defined in the Docker commands or in the Docker Compose file.
    
2. **Configuration Options**: You have the ability to control certain aspects of Cgroups through Docker options. For example, you can set limits on CPU and memory when running a container:
    
-  To limit memory, you can use the `--memory` flag:
```bash
docker run --memory="512m" your_image
```

- To limit CPU, you can use the `--cpus` flag:
```bash
docker run --cpus="1.5" your_image
```

- **Custom Cgroup Settings**: For more advanced configurations, you can modify the Docker daemon's configuration to customize how Cgroups are set up. This might involve editing the Docker configuration file (typically found at `/etc/docker/daemon.json`) to define specific resource limits for all containers.
    
- **Direct Control**: If you need to manage Cgroups directly, you can access the Cgroup filesystem (usually located at `/sys/fs/cgroup`) on the host. However, this is generally not necessary for standard Docker usage, as Docker's built-in management is usually sufficient.