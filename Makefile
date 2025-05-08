# same as docker build --build-arg PORT=80 --build-arg NODE_ENV=DEVELOPMENT -t app:latest .
# make build args="PORT=80 NODE_ENV=DEVELOPMENT" version=latest
build:
	docker build --build-arg $(args) -t app:$(version) .

# make run version=latest
run:
	docker run --rm -it --env-file .env -p 8080:8080 app:$(version)

# make rm version=latest
rm: 
	docker image rm app:$(version)
