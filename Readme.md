Docker Memo
===========

You can find here somes tips and tricks for Docker.

Don't use SSH
-------------

From https://github.com/jpetazzo/nsenter

	docker run --rm jpetazzo/nsenter cat /nsenter > /usr/local/bin/nsenter
	wget -q https://raw.githubusercontent.com/jpetazzo/nsenter/master/docker-enter -O /usr/local/bin/docker-enter
	chmod +x /usr/local/bin/nsenter /usr/local/bin/docker-enter

Then enter in your container (use --name when you run it or simply docker ps to get the name)

	sudo docker-enter <container_name>

Since Docker 1.3 you can directly use docker exec

	docker exec -it <container_name> /bin/bash


Don't forget MAINTAINER
-----------------------

	MAINTAINER Ahmet Demir <ahmet2mir+github@gmail.com>

Forward request and error logs to docker log collector (docker logs <image>)
----------------------------------------------------------------------------

    RUN ln -sf /dev/stdout /var/log/<myimage>/access.log \
        && ln -sf /dev/stderr /var/log/<myimage>/error.log


If you use an init script, create status file to be idempotent
--------------------------------------------------------------

At the end 

	echo "done" > /.dockerstatus

Check it

	if [ ! -f /.dockerstatus ]; then

You can find an example in src/docker-entry.sh

Front Dialog error with Debian and APT
--------------------------------------

Add 

	ENV DEBIAN_FRONTEND noninteractive

Don't reinvent the wheel
------------------------

For example, if nginx has an official image, use it (FROM nginx:latest)

Use "public" IP in Docker (no NAT)
----------------------------------

With --net=host param when you run docker, all you NIC are in Docker and you do not need to expose port.
Example:

	$ docker run -d --net=host --name nginx nginx
	$ curl 0.0.0.0
	<!DOCTYPE html>
	<html>
	<head>
	<title>Welcome to nginx!</title>
	<style>
	    body {
	        width: 35em;
	        margin: 0 auto;
	        font-family: Tahoma, Verdana, Arial, sans-serif;
	    }
	</style>
	</head>
	<body>
	<h1>Welcome to nginx!</h1>
	<p>If you see this page, the nginx web server is successfully installed and
	working. Further configuration is required.</p>

	<p>For online documentation and support please refer to
	<a href="http://nginx.org/">nginx.org</a>.<br/>
	Commercial support is available at
	<a href="http://nginx.com/">nginx.com</a>.</p>

	<p><em>Thank you for using nginx.</em></p>
	</body>
	</html>


/!\ Note: the host mode gives the container full access to local system services such as D-bus and is therefore considered insecure

Allow user to use docker without root privilege
-----------------------------------------------

	sudo groupadd docker
	sudo gpasswd -a ${USER} docker
	sudo service docker restart
	# log out and log in


Disable IPV6 for nginx
----------------------

Some servers don't support IPv6, so the container can't start with default nginx configuration

	# disable ipv6 support
	if [ ! -f /proc/net/if_inet6 ]; then
	  sed -e '/listen \[::\]:80/ s/^#*/#/' -i /etc/nginx/sites-enabled/*
	fi

View all commands / commit / layer ordered
------------------------------------------
	
	image=<my_image>
	docker history --no-trunc $image | awk '{for (i=5; i<=NF; i++)printf "%s ",$i;printf "\n"}' | tac

Other
-----
https://docs.docker.com/articles/basics/
http://www.centurylinklabs.com/15-quick-docker-tips/
