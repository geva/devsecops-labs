# Update system
sudo apt-get update

# Setup necessary tools
sudo apt-get -y install wget curl python3-pip python3-venv

# Setup XRDP
sudo apt-get -y install xrdp xfce4
# echo xfce4-session >~/.xsession 


# Setup Docker
curl -sSL https://get.docker.com/ | sh


# Setup ZAP
cd ~
mkdir -p zap
cd zap
wget -N https://github.com/zaproxy/zaproxy/releases/download/2.7.0/ZAP_2.7.0_Linux.tar.gz
tar -zxvf ZAP_2.7.0_Linux.tar.gz
rm ZAP_2.7.0_Linux.tar.gz
cd ZAP_2.7.0/plugin
wget https://github.com/zaproxy/zap-extensions/releases/download/2.7/exportreport-alpha-5.zap
echo 'export PATH_ZAP_SH=/root/zap/ZAP_2.7.0/zap.sh' >> ~/.bashrc
echo 'export ZAP_PORT=8090' >> ~/.bashrc
echo 'sh -c "$PATH_ZAP_SH -daemon -host 0.0.0.0 -port $ZAP_PORT -configfile /root/zap/ZAP_2.7.0/conf" > /dev/null & ' > start-zap
echo 'sleep 40' >> start-zap
echo 'sh -c "$PATH_ZAP_SH -host 0.0.0.0 -port $ZAP_PORT -configfile /root/zap/ZAP_2.7.0/conf" > /dev/null & ' > start-gui-zap
echo 'sleep 40' >> start-gui-zap
chmod +x start-zap
chmod +x start-gui-zap
mv start-zap /usr/local/bin/start-zap
echo 'pkill -f zap' > stop-zap
chmod +x stop-zap
mv stop-zap /usr/local/bin/stop-zap

# Setup findsecbugs
cd ~
mkdir sast-findsecbugs
cd sast-findsecbugs
wget https://github.com/find-sec-bugs/find-sec-bugs/releases/download/version-1.9.0/findsecbugs-cli-1.9.0.zip
unzip findsecbugs-cli-1.9.0.zip
wget https://github.com/WebGoat/WebGoat/releases/download/7.1/webgoat-container-7.1-exec.jar
sed -i -e 's/\r$//' findsecbugs.sh
echo 'bash findsecbugs.sh -progress -html -output report.html webgoat-container-7.1-exec.jar' > run.sh
chmod +x run.sh


# Setup Terraform
cd ~
mkdir terraform
cd terraform
wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
unzip terraform_0.11.13_linux_amd64.zip
rm terraform_0.11.13_linux_amd64.zip
sudo mv terraform /usr/local/bin/


# Setup AWS CLI
pip3 install awscli


# Setup Brakeman - RailsGoat
sudo apt-get install -y rubygems
gem install brakeman
cd ~
mkdir sast-brakeman
cd sast-brakeman
git clone https://github.com/OWASP/railsgoat.git
# brakeman -p /root/sast-brakeman/railsgoat/ -o brakeman-result.html


# Setup Bandit - CTF2
cd ~
mkdir sast-bandit
cd sast-bandit
pip3 install bandit
git clone https://github.com/we45/CTF2.git
# bandit -r -f html -o bandit-result.html /root/sast-bandit/CTF2/


# Setup NodeJSScan - CutTheFund
cd ~
mkdir sast-nodejsscan
cd sast-nodejsscan
pip3 install nodejsscan
git clone https://github.com/we45/Cut-The-Funds-NodeJS.git
# nodejsscan -d /root/sast-nodejsscan/Cut-The-Funds-NodeJS/ -o nodejscan-report


# Setup NPMAudit - CutTheFund
cd ~
mkdir sca-npmaudit
cd sca-npmaudit
cp -r /root/sast-nodejsscan/Cut-The-Funds-NodeJS $PWD 
sudo apt-get install -y nodejs npm
npm install npm@6 -g
npm install -g npm-audit
cd Cut-The-Funds-NodeJS
npm install
# npm audit --json >> report.json


# Setup RetireJS - CutTheFund
cd ~
mkdir sca-retirejs
cd sca-retirejs
cp -r /root/sast-nodejsscan/Cut-The-Funds-NodeJS $PWD
npm install -g retire
npm install
# retire --path $PWD --outputformat json --outputpath $PWD/retirejs-report.json


# Setup Safety - VulFlask
cd ~
mkdir sca-safety
cd sca-safety
git clone https://github.com/we45/Vulnerable-Flask-App.git
cd Vulnerable-Flask-App
pip3 install safety
# safety check --json
# safety check --full-report


# Setup DepCheck - WebGoat
cd ~
mkdir sca-depcheck
cd sca-depcheck
wget https://dl.bintray.com/jeremy-long/owasp/dependency-check-4.0.2-release.zip
unzip dependency-check-4.0.2-release.zip
git clone https://github.com/hamhc/WebGoat-7.1.git
sudo apt-get install -y openjdk-8-jdk maven 
cd WebGoat-7.1/webgoat-container/
mvn install -Dmaven.test.skip=true
cd /root/sca-depcheck
# sh dependency-check/bin/dependency-check.sh -n -f HTML -f XML --project "Test Scan" --scan WebGoat-7.1/webgoat-container/
# sh dependency-check/bin/dependency-check.sh -f HTML -f XML --project "Test Scan" --scan WebGoat-7.1/webgoat-container/


# Setup DepTrack - CutTheFund
cd ~
mkdir sca-deptrack
cd sca-deptrack
git clone https://github.com/we45/Cut-The-Funds-NodeJS.git
cd Cut-The-Funds-NodeJS
npm install
docker pull owasp/dependency-track
docker volume create --name dependency-track
docker run -d -p 8080:8080 --name dependency-track -v dependency-track:/data owasp/dependency-track
cyclonedx-bom -o bom.xml


# Setup ZAP
cd ~
mkdir dast-zap
cd dast-zap
git clone https://github.com/we45/ZAP-Mini-Workshop.git
pip install python-owasp-zap-v2.4==0.0.14 


# Setup Robot - Basics
cd ~
mkdir robo-basics
cd robo-basics
git clone https://github.com/we45/defcon26.git
mv defcon26 scripts
cd scripts/basics
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
robot Robo101.robot
docker run -d -p 5050:5050 abhaybhargav/vul_flask
robot RESTExample.robot
clean-doc



# Setup Commit-hook - Bandit
cd ~
mkdir commit-hook-bandit
cd commit-hook-bandit
git clone https://github.com/we45/Vulnerable-Flask-App.git
cd Vulnerable-Flask-App
cp bandit-commit-hook.sh .git/hooks/post-commit
chmod +x .git/hooks/post-commit
cp malicious_file.py $pwd
# git add -A
# git config user.name "testuser"
# git config user.email "testuser@gmail.com"
# git commit -m "Commited insecure python file"


# Setup Commit-hook - ESLint
cd ~
mkdir commit-hook-eslint
cd commit-hook-eslint
git clone https://github.com/we45/Cut-The-Funds-NodeJS.git
cd Cut-The-Funds-NodeJS
npm install -g eslint eslint-plugin-security
cp eslintrc.js .eslintrc.js
cp eslint-commit-hook.sh .git/hooks/post-commit
chmod +x .git/hooks/post-commit
cp insecure_node_code.js $pwd
# git add -A
# git config user.name "testuser"
# git config user.email "testuser@gmail.com"
# git commit -m "Commited insecure node file"


# Setup Dockerized-labs - NodeJSScan
cd ~
mkdir dockerized-labs
cd dockerized-labs
git clone https://github.com/we45/Cut-The-Funds-NodeJS.git
mkdir -p results
# docker run --rm -v $PWD/Cut-The-Funds-NodeJS:/src  -v $(pwd)/results:/results abhaybhargav/nodejsscan


# Setup Selenium Walkthrough
cd ~
mkdir selenium
virtualenv venv -p python3
source venv/bin/activate
pip install python-owasp-zap-v2.4==0.0.14 selenium==3.14.1


# Setup Nightwatch
cd ~
mkdir nigthwatch
cd nigthwatch
git clone https://github.com/we45/Nightwatch-ZAP.git 
cd Nightwatch-ZAP
npm install
# docker run -d -p 9000:80 nithinwe45/wecare
virtualenv venv -p python3
source venv/bin/activate
cd rpc
pip install -r requirements.txt
python ZAPRPC.py


# Setup Bash Scripts

echo 'docker run -d -p 5050:5050 abhaybhargav/vul_flask' > /usr/local/bin/start-vul-flask
chmod +x /usr/local/bin/start-vul-flask
echo -e 'docker run -d -p 9000:80 --name wecare nithinwe45/wecare \nsleep 60' > /usr/local/bin/start-wecare
chmod +x /usr/local/bin/start-wecare


# Setup Browsers
cd ~
mkdir browsers
cd browsers
sudo apt-get install -y firefox
sudo apt-get install -y xdg-utils
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
# Setup Browser drivers
mkdir webdrivers
cd webdrivers
wget https://chromedriver.storage.googleapis.com/73.0.3683.68/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
mv chromedriver /usr/local/bin/
which google-chrome
# exec -a "$0" "$HERE/chrome" "--no-sandbox" "$@"

wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz
tar -xzvf geckodriver-v0.24.0-linux64.tar.gz
mv geckodriver /usr/local/bin/


# Setup RoboZAP
cd ~
mkdir robo_zap
cd robo_zap
virtualenv venv
source venv/bin/activate
# pip install -r requirements.txt
pip install RoboZap==1.2.6 python-owasp-zap-v2.4==0.0.14


# Setup Tavern
cd ~
mkdir tavern-cli
virtualenv venv -p python3
source venv/bin/activate
pip install -r requirements.txt
echo 'tavern-ci --log-to-file result.log test_ctf.tavern.yaml' > run.sh
chmod +x run.sh
pip install docker-compose
sh run.sh




# Setup terminator
sudo apt-get install -y terminator

# Setup WecareWalkthrough Robot
cd ~
mkdir robo-wecare-walkthrough
cd robo-wecare-walkthrough
virtualenv venv -p python3
source venv/bin/activate
# pip install -r requirements.txt
pip install robotframework-selenium2library==3.0.0


# Setup Bandit Custom Cli
cd ~
mkdir sast-bandit-custom
cd sast-bandit-custom
virtualenv venv
source venv/bin/activate
pip install bandit==1.5.1
cp jwt_verify_test.py venv/lib/python2.7/site-packages/bandit/plugins/
git clone https://github.com/we45/Vulnerable-Flask-App.git
# vim venv/lib/python2.7/site-packages/bandit-1.5.1.dist-info/entry_points.txt
# Add `jwt_decode = bandit.plugins.jwt_verify_test:unsafe_jwt_verify` in the plugins section


# Setup Pentest Robo Pipeline
cd ~
mkdir pentest-robo-pipeline
cd pentest-robo-pipeline


# Setup Python Robo Pipeline
cd ~
mkdir python-robo-pipeline
cd python-robo-pipeline


# Setup Robot Node Pipeline
cd ~
mkdir robo-node-pipeline
cd robo-node-pipeline
# cp docker-compose.yaml 


# Setup ZAP Python Scripts
cd ~
mkdir zap-python-scripts
cd zap-python-scripts




# Update system
sudo apt-get update


# Setup necessary tools
sudo apt-get -y install wget curl python3-venv


# Setup Orchestron Community
cd ~
mkdir orchy-community
cd orchy-community
wget https://raw.githubusercontent.com/we45/orchestron-community/master/docker-compose.yml
sudo apt-get install -y python-pip
pip install docker-compose
docker-compose up -d


# Setup ThreatPlayBook
cd ~
mkdir threatplaybook
cd threatplaybook
wget https://raw.githubusercontent.com/we45/ThreatPlaybook/master/docker-compose.yaml
docker-compose up -d


# Setup Jenkins
sudo apt-get install -y openjdk-8-jdk openjdk-8-jre-headless
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins
sudo usermod -a -G docker jenkins
# export IP="$(hostname -I | awk '{print $1}')"
# wget http://$IP:8080/jnlpJars/jenkins-cli.jar
sudo service jenkins stop


# Setup SAST tools
sudo apt-get -y install python3-pip
pip3 install nodejsscan
sudo apt-get install -y nodejs npm
npm install npm@6 -g
npm install -g npm-audit



# Setup JavaVulnerableLab
sudo apt-get -y install git
git clone https://github.com/CSPF-Founder/JavaVulnerableLab.git
cd JavaVulnerableLab
sudo apt-get install -y maven
mvn package


# Setup GitLab CI
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
sudo wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
sudo chmod +x /usr/local/bin/gitlab-runner
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo gitlab-runner register
sudo gitlab-runner start                                       


# Setup RubyPipeline
sudo apt-get install -y ruby-full
gem install brakeman
gem install bundler
gem install bundler-audit


# Setup Python Pipeline
pip install bandit safety



