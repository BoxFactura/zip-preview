UBUNTU_VERSIONS = 20.04 22.04 24.04

default: all

all: build

build:
	@for version in $(UBUNTU_VERSIONS); do \
		docker build --build-arg UBUNTU_VERSION=$$version -t ubuntu-$$version -f Dockerfile.template .; \
		if docker inspect bxfzipcont >/dev/null 2>&1; then \
			docker rm -f bxfzipcont; \
		fi; \
		docker create --name bxfzipcont ubuntu-$$version; \
		docker cp bxfzipcont:/app/dist/bxfzip ./bin/bxfzip-ubuntu-$$version\_amd64; \
		docker rm -f bxfzipcont; \
		gzip -9 bin/bxfzip-ubuntu-$$version\_amd64; \
		#rm bin/bxfzip-ubuntu-$$version\_amd64; \
	done

	#chmod +x python_binary_extractor
	#docker rmi python-ubuntu-20.04 python-ubuntu-22.04 python-ubuntu-24.04 || true
