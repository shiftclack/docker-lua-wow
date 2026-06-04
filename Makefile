.PHONY: build

build:
	@docker buildx build -t lua-wow:latest .
