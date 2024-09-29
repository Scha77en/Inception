
## What Is NGINX?

NGINX is open-source web server software used for reverse proxy, load balancing, and caching. It provides HTTPS server capabilities and is mainly designed for maximum performance and stability. It also functions as a proxy server for email communications protocols, such as IMAP, POP3, and SMTP. 

## The NGINX Architecture

By implementing event-driven, asynchronous, and non-blocking models, NGINX uses master-slave architecture.

It also uses an advanced event-based mechanism in many operating systems. Additionally, NGINX uses multiplexing and event notifications and dedicates specific tasks to separate processes. For example, if you have 10 tasks, 10 different processes will handle each of them. NGINX processes highly efficient run loops in a single-thread process called workers.

- **Workers** accept new requests from a shared listen socket and execute highly efficient run loops inside each worker to process thousands of requests. 
- **Masters** read and validate configurations by creating, binding, and crossing sockets. They also handle starting, terminations, and maintaining the number of configured worker processes. The master node can also reconfigure the worker process with no service interruption.
- **Proxy caches** are special processes. They have a cache loader and manager. The cache loader checks the disk cache item and populates the engine’s in-memory database with the cache metadata. It prepares the NGINX instances to work with the files already stored on the disk in a specifically allocated structure. The cache manager handles cache expiration and invalidation.

## Benefits of NGINX

Using NGINX comes with several benefits, including the following:

- Reduces the waiting time to load a website. You don’t have to worry about high latency on your websites, therefore providing a good user experience. 
- Speeds up performance by routing traffic to web servers in a way that increases the overall speed. This feature provides a good browsing experience to your users.
- Acts as an inexpensive and robust load balancer.
- Offers scalability and the ability to handle concurrent requests. 
- Allows on-the-fly upgrades without downtime.

## Limitations of NGINX

Although NGINX has lots of benefits, there are some limitations, too. It has a low level of community support and contributions from developers, leading to fewer features and updates. Both maintenance and setup require expert knowledge.

Although NGINX is free to use, it also has a paid version called NGINX Plus, an all-in-one load balancer, content cache, web server, API gateway, and microservices proxy that costs $2,500 per year.

## Use Cases

An instance of NGINX can be configured as any of the following:

- A web server. This is the most common because of its performance and scalability.
- A reverse proxy server. NGINX does this by directing the client’s request to the appropriate back-end server.
- A load balancer. It automatically distributes your network traffic load without manual configuration.
- An API gateway. This is useful for request routing, authentication, and exception handling.
- A firewall for web applications. This protects your application by filtering incoming and outgoing network requests on your server.
- A cache. NGINX acts as a cache to help store your data for future requests.
- Protection against distributed-denial-of-service (DDoS) attacks.
- K8s. These automate deployments and scaling and manage containerized applications.
- A sidecar proxy. This routes traffic to and from the container it runs alongside.


### Dockerfile

```Dockerfile
FROM debian:bullseye

  

RUN apt update && apt install -y nginx openssl

  

# Generate self-signed SSL certificate

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \

-keyout /etc/ssl/private/nginx-selfsigned.key \

-out /etc/ssl/certs/nginx-selfsigned.crt \

-subj "/C=MA/ST=State/L=KH/O=1337/CN=aouhbi.42.fr"

  

COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default



EXPOSE 443

  

CMD ["nginx", "-g", "daemon off;"]
```

#### `FROM debian:bullseye`

- **Base Image**: The Dockerfile starts by using Debian Bullseye as the base image, a minimal Debian distribution.

#### 2. `RUN apt update && apt install -y nginx openssl`

- **Install NGINX and OpenSSL**: Updates the package list and installs NGINX (web server) and OpenSSL (for generating SSL certificates).

#### 3. `RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \`

- **Generate SSL Certificate**: This command generates a self-signed SSL certificate.
    - `-x509`: Create a self-signed certificate.
    - `-nodes`: No passphrase for the private key.
    - `-days 365`: The certificate is valid for 365 days.
    - `-newkey rsa:2048`: Create a new RSA key with a 2048-bit size.
    - `-keyout /etc/ssl/private/nginx-selfsigned.key`: The private key is saved at this location.
    - `-out /etc/ssl/certs/nginx-selfsigned.crt`: The certificate is saved at this location.
    - `-subj "/C=MA/ST=State/L=KH/O=1337/CN=aouhbi.42.fr"`: Defines the certificate subject, including country (C), state (ST), location (L), organization (O), and common name (CN) for the domain.

#### 4. `COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default`

- **Copy NGINX Configuration**: Copies a custom NGINX configuration file (`nginx.conf`) from the `./conf` directory into the container, replacing the default configuration in `/etc/nginx/sites-enabled/default`.

#### 5. `EXPOSE 443`

- **Expose Port 443**: Specifies that the container will listen for traffic on port 443 (HTTPS).

#### 6. `CMD ["nginx", "-g", "daemon off;"]`

- **Run NGINX**: This sets the container to start NGINX in the foreground (`daemon off`) when it is run, ensuring the container doesn’t exit immediately after starting.


### NGINX config file

```conf
server

{

listen 443 ssl;

server_name aouhbi.42.fr localhost;

  

ssl_protocols TLSv1.2 TLSv1.3;

ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;

ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

  

root /var/www/html/;

index index.php;

  

location ~ [^/]\.php(/|$) {

fastcgi_pass wordpress:9000;

fastcgi_index index.php;

include fastcgi_params;

fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

}

}
```


#### `server { ... }`

This defines a server block, which handles a specific set of requests for the server. Everything inside the curly braces `{}` configures how NGINX should handle these requests.

#### `listen 443 ssl;`

- **listen 443**: Instructs NGINX to listen on port 443, which is the default port for HTTPS.
- **ssl**: Indicates that SSL/TLS should be used for secure connections on this port.

#### `server_name aouhbi.42.fr localhost;`

- **server_name**: Defines the domain names this server block will respond to. Here, it will handle requests for `aouhbi.42.fr` and `localhost`.

#### `ssl_protocols TLSv1.2 TLSv1.3;`

- Specifies the SSL/TLS protocols that the server supports. In this case, only **TLS 1.2** and **TLS 1.3** are allowed, which are more secure than older protocols.

#### `ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;`

- This points to the location of the **SSL certificate** file. In this case, it's a self-signed certificate located at `/etc/ssl/certs/nginx-selfsigned.crt`.

#### `ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;`

- Specifies the path to the **private key** that corresponds to the SSL certificate. This key is required for secure communication.

#### `root /var/www/html/;`

- **root**: Sets the root directory where NGINX will serve files from. In this case, it’s set to `/var/www/html/`, meaning this is where NGINX looks for static files like HTML, CSS, etc.

#### `index index.php;`

- **index**: Specifies the default file to serve if a directory is requested. Here, **index.php** will be served as the default file if available (i.e., for `/`, NGINX will serve `/var/www/html/index.php`).

#### `location ~ [^/]\.php(/|$) { ... }`

- **location ~ [^/].php(/|$)**: This block matches any request for PHP files. The `~` indicates a regular expression is being used. This expression matches any file ending in `.php`, with an optional trailing slash (`/`).

#### `fastcgi_pass wordpress:9000;`

- **fastcgi_pass**: Defines where to pass PHP requests. Here, it forwards PHP requests to **port 9000** on the container named **wordpress**, where PHP-FPM (FastCGI Process Manager) is running.

#### `fastcgi_index index.php;`

- **fastcgi_index**: Specifies the default PHP file to handle if the request is for a directory. If someone requests `/`, it will serve `/index.php` through FastCGI.

#### `include fastcgi_params;`

- This includes the default FastCGI parameters provided by NGINX, which are required to pass certain environment variables and settings to the PHP FastCGI process.

#### `fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;`

- **fastcgi_param SCRIPT_FILENAME**: This sets the `SCRIPT_FILENAME` parameter, telling PHP-FPM which file to execute.
- `$document_root`: Expands to the value of `root`, which is `/var/www/html/`.
- `$fastcgi_script_name`: Represents the requested PHP script, like `/index.php`.

#### Overall Purpose

This configuration handles requests for an HTTPS server that serves PHP files. It uses FastCGI (with PHP-FPM) to process PHP scripts, and it ensures secure communication via SSL with a self-signed certificate. The site responds to requests for the domain `aouhbi.42.fr` and `localhost`.