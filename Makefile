.PHONY: dev build lint install clean

dev:
	cd website && npm run dev

build:
	cd website && npm run build

lint:
	cd website && npm run lint

install:
	cd website && npm install

clean:
	rm -rf website/.next website/node_modules
