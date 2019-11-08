init:
	@which mkcert 2>&1 >/dev/null || brew install mkcert
	@brew info nss 2>&1 >/dev/null || brew install nss
	mkcert -cert-file config/certs/localhost.crt.pem -key-file config/certs/localhost.key.pem localhost

install:
	bundle install

start:
	bundle exec rails s
