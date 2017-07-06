TARGET ?= vancouver
CONCOURSE_URL ?= https://ci.from-the.cloud/
GITHUB_ID ?= c29a4757ff0e43c25610
GITHUB_TEAM ?= 'SUSE/Team Alfred'

all: pipeline-check

login-vancouver:
	fly -t vancouver login  --concourse-url https://ci.from-the.cloud

login-sandbox:
	fly -t sandbox login  --concourse-url http://192.168.100.4:8080/

pipeline-check:
	yes | fly -t ${TARGET} set-pipeline -c fissile-stemcell-openSUSE-check.yml -p fissile-stemcell-openSUSE-check -l ../cloudfoundry/secure/concourse-secrets.yml
	fly -t ${TARGET} unpause-pipeline -p fissile-stemcell-openSUSE-check
