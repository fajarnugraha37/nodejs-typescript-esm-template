build:
	docker build -t app:$(version) .

run:
	docker run --rm -it --env-file .env -p 3000:3000 app:$(version)

rm: 
	docker image rm app:$(version)
