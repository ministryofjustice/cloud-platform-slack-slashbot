IMAGE := ministryofjustice/cloud-platform-slashbot
TAG := 1.0

.built-image: Dockerfile Gemfile Gemfile.lock makefile
	docker build -t $(IMAGE) .
	touch .built-image

push: .built-image
	docker tag $(IMAGE) $(IMAGE):$(TAG)
	docker push $(IMAGE):$(TAG)

build: .built-image

clean:
	docker rmi $(IMAGE) --force
	docker rmi $(TAGGED) --force
	rm .built-docker-image