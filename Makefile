all: build
build:
	# Build Docker images for each Ubuntu version using the template
	docker build --build-arg UBUNTU_VERSION=20.04 -t python-ubuntu-20.04 -f Dockerfile.template .
	#docker build --build-arg UBUNTU_VERSION=22.04 -t python-ubuntu-22.04 -f Dockerfile.template .
	#docker build --build-arg UBUNTU_VERSION=24.04 -t python-ubuntu-24.04 -f Dockerfile.template .

	# Run containers and extract binaries
	#docker run --rm -v $(CURDIR)/output:/app/dist python-ubuntu-20.04
	#docker run --rm -v $(CURDIR)/output:/app/output --user $(id -u):$(id -g) python-ubuntu-22.04
	#docker run --rm -v $(CURDIR)/output:/app/output --user $(id -u):$(id -g) python-ubuntu-24.04

	#docker cp python-ubuntu-20.04:/app/dist/script .
	docker create --name dummy python-ubuntu-20.04
	docker cp dummy:/app/dist/script ./sss
	docker rm -f dummy
	# Verify contents of the output directory
	# 	docker run --rm -v $(CURDIR)/output:/app/output --entrypoint /bin/sh python-ubuntu-20.04 -c 'ls -laR /app'

	# Create a gzipped file for each binary
	#gzip -k output/script_ubuntu_20.04
	#gzip -k output/script_ubuntu_22.04
	#gzip -k output/script_ubuntu_24.04

	# Package the gzipped binaries into a Ruby gem
	#gem build python_binaries.gemspec

	# Create the Ruby extractor script
	#chmod +x python_binary_extractor

	# Clean up Docker images
	#docker rmi python-ubuntu-20.04 python-ubuntu-22.04 python-ubuntu-24.04 || true
