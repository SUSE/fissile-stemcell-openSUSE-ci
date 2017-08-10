TARGET ?= skycastle
CONCOURSE_URL ?= https://ci.from-the.cloud/
GITHUB_ID ?= c29a4757ff0e43c25610
GITHUB_TEAM ?= 'SUSE/Team Alfred'
CONCOURSE_SECRETS_FILE ?= ../cloudfoundry/secure/concourse-secrets.yml.gpg
TMP_SECRETS_FILE := $(shell mktemp -t tmp-concourseXXXXXX)

all: pipeline-check

login-vancouver:
	fly -t vancouver login  --concourse-url https://ci.from-the.cloud

login-sandbox:
	fly -t sandbox login  --concourse-url http://192.168.100.4:8080/

pipeline-check:
	gpg --decrypt --batch --no-tty ${CONCOURSE_SECRETS_FILE} > ${TMP_SECRETS_FILE}
	yes | fly -t ${TARGET} set-pipeline -c fissile-stemcell-openSUSE-check.yml -p fissile-stemcell-openSUSE-check -l ${TMP_SECRETS_FILE}
	fly -t ${TARGET} unpause-pipeline -p fissile-stemcell-openSUSE-check
	rm -f ${TMP_SECRETS_FILE}
