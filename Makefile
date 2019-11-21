net:
	docker network create --driver overlay  --attachable mynet 
n1:
	docker run -d --net mynet --name green nginx 
n2:
	docker run -d --net mynet --name blue nginx 
n3:
	docker run -d --net mynet --name red nginx 
h:
	docker rm -f hap || echo done
	#docker run -d -v $$PWD/haproxy_http.cfg://usr/local/etc/haproxy/haproxy.cfg -p 80:80 -p 81:81 --net mynet --name hap haproxy
	docker run -d -v $$PWD/haproxy_tcp.cfg://usr/local/etc/haproxy/haproxy.cfg -p 80:80 -p 81:81 --net mynet --name hap haproxy
	sleep 1
	docker logs hap
ps:
	docker ps -a 
j:
	docker run -d -v $$PWD/Makefile:/Makefile --net mynet --name jumpbox  alpine:3.10 tail -f /dev/null

cp:
	docker cp green.html green:/usr/share/nginx/html/index.html
	docker cp blue.html blue:/usr/share/nginx/html/index.html
	docker cp red.html red:/usr/share/nginx/html/index.html
bash:
	docker exec -it jumpbox ash

test:
	curl -v -H "HOST: green.me" localhost 
	curl -H "HOST: blue.me" localhost 

t1:
	curl -H "Host: red" localhost
	curl -H "Host: blue" localhost
	curl -H "Host: green" localhost
	curl -H "Host: blk" localhost
tr:
	wget -O - --header "Host: red" hap
	curl -H"Host: blue" hap
	curl -H"Host: green" hap
