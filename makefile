IMAGE := ministryofjustice/cloud-platform-slashbot
TAG := 1.1

.built-image: Dockerfile Gemfile Gemfile.lock makefile
	docker build -t $(IMAGE) .
	touch .built-image

docker-push: .built-image
	docker tag $(IMAGE) $(IMAGE):$(TAG)
	docker push $(IMAGE):$(TAG)

build: .built-image

clean:
	docker rmi $(IMAGE) --force
	docker rmi $(TAGGED) --force
	rm .built-docker-image