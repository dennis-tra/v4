deploy: build
	rsync -hr --delete --progress ./public root@dtrautwein.eu:/var/www/dtrautwein.eu

build:
	yarn build
