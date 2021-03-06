NAME = hademo
run:
	docker stack deploy -c docker-compose.yml ${NAME}
init:
	docker swarm init  --advertise-addr $$(ip addr | grep inet | grep eth1 | cut -d" " -f 6 | cut -d"/" -f1)  # for Play-with-docker.com

build:
	docker build -t awesome .
logs:
	docker logs $$(docker ps -q -f name=hademo_proxy)

ps:
	docker stack ps ${NAME}
clean:
	docker stack rm ${NAME}

all: init build run
