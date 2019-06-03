docker run -d -p 5432:5432 --name db arminc/clair-db:latest
docker run -d -p 6060:6060 --link db:postgres --name clair arminc/clair-local-scan:latest
docker pull abhaybhargav/vul_flask:latest
export IP="$(hostname -I | awk '{print $1}')"
./clair-scanner --ip $IP -r clair_report.json abhaybhargav/vul_flask:latest