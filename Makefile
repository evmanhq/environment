build:
	docker build -t registry.gitlab.com/evman/environment .

release: build
	docker push registry.gitlab.com/evman/environment
