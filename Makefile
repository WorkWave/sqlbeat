BEATNAME=sqlbeat
BEATVERSION=5.0.0
BUILDNUM=1
SQLBEATVERSION=$(BEATVERSION)-$(BUILDNUM)
BEAT_DIR=github.com/workwave
SYSTEM_TESTS=false
TEST_ENVIRONMENT=false
ES_BEATS=./vendor/github.com/elastic/beats
GOPACKAGES=$(shell glide novendor)
#DIST_DIR=${BUILD_DIR}/dist/sqlbeat-$(SQLBEATVERSION)-windows-x86_64
DIST_DIR=${BUILD_DIR}/dist
DIST_NAME=sqlbeat-$(SQLBEATVERSION)-windows-x86_64
DIST_ZIPFILE=$(DIST_NAME).zip
DIST_ZIPFILE_PATH=$(DIST_DIR)/$(DIST_ZIPFILE)
PREFIX?=.

# Path to the libbeat Makefile
-include $(ES_BEATS)/libbeat/scripts/Makefile

.PHONY: init
init:
	glide update  --no-recursive
	make update
	git init

.PHONY: update-deps
update-deps:
	glide update  --no-recursive

# This is called by the beats packer before building starts
.PHONY: before-build
before-build:

.PHONY: windows
windows: $(GOFILES)
	mkdir -p ${BUILD_DIR}/bin
	gox -output="${BUILD_DIR}/bin/{{.Dir}}-{{.OS}}-{{.Arch}}" -osarch="windows/amd64" ${GOX_FLAGS}

.PHONY: dist
dist: windows
	mkdir -p ${DIST_DIR}/${DIST_NAME}
	cp ${BUILD_DIR}/bin/sqlbeat-windows-amd64.exe ${DIST_DIR}/${DIST_NAME}/sqlbeat.exe
	cp sqlbeat.yml ${DIST_DIR}/${DIST_NAME}
	mkdir -p ${DIST_DIR}/${DIST_NAME}/scripts
	cp scripts/* ${DIST_DIR}/${DIST_NAME}

.PHONY: zip
zip: dist
	cd ${DIST_DIR} && pwd && zip -r ${DIST_ZIPFILE} ${DIST_NAME}
	@echo Zipfile is in ${DIST_ZIPFILE_PATH}

.PHONY: rel
rel:
	@echo Create the release on git
	curl -H 'Content-Type: application/json' -d '{"tag_name": "v${BEATVERSION}-${BUILDNUM}", "target_commitish": "master", "name": "v${BEATVERSION}-${BUILDNUM}", "body": "Release ${BEATVERSION}-${BUILDNUM}"}' http://github.com/repos/bhazard/sqlbeat/releases
	echo send ${DIST_FILE} to git

