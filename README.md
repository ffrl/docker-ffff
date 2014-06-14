This is a Dockerfile for the FFFF NodeJS service (FreiFunk Fastd Form). In order to build the image run the following command inside the folder:

	 docker build -t="ffff" .

The FFFF service uses UID/GID 2000 inside the docker image. So we create user on the host system with the same UID/GID:

	useradd -U -u 2000 -d /opt/ffff ffff

Afterwards you have to create the host folder which will be bound as virtual volume and change the user who owns it:

	mkdir -p /opt/ffff/peers/yourcommunity
	chown ffff.ffff /opt/ffff/peers/yourcommunity -R

You may now start the docker image, if your docker daemon is set to auto-restart your service will automatically restart if you reboot or restart docker.
Run the following command to run the image in background:

	docker run -p 127.0.0.1:8080:8080 -v /opt/ffff/peers/yourcommunity:/opt/peers -d ffff

FFFF will be exposed on port 8080 on 127.0.0.1 of the host machine, you may now set up a reverse proxy configuration for Nginx or Apache.
This is however not covered by this example.
You can also expose the service directly to the internet on port 80 if you start it the following way:

	docker run -p 0.0.0.0:80:8080 -v /opt/ffff/peers/yourcommunity:/opt/peers -d ffff

Since NodeJS is single threaded, you may want to go for the reverse proxy configuration and only forward api calls to docker.
