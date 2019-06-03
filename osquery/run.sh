docker run -d --privileged nginx:latest
docker run -e MYSQL_ROOT_PASSWORD=my-secret-pw  -v /etc:/hostFS -d mysql:latest

osqueryi