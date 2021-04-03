CONFIG_PATH=${HOME}/.proglog

.PHONY: init
init:
	mkdir -p ${CONFIG_PATH}
	go get github.com/cloudflare/cfssl/cmd/cfssl@v1.4.1
	go get github.com/cloudflare/cfssl/cmd/cfssljson@v1.4.1

.PHONY: gencert
gencert:
	cfssl gencert \
		-initca test/ca-csr.json | cfssljson -bare ca
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=server \
		test/server-csr.json | cfssljson -bare server
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=client \
		-cn="root" \
		test/client-csr.json | cfssljson -bare root-client
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=client \
		-cn="nobody" \
		test/client-csr.json | cfssljson -bare nobody-client
	mv *.pem *.csr ${CONFIG_PATH}

$(CONFIG_PATH)/acl-model.conf:
	cp test/acl-model.conf $(CONFIG_PATH)/acl-model.conf

$(CONFIG_PATH)/acl-policy.csv:
	cp test/acl-policy.csv $(CONFIG_PATH)/acl-policy.csv

.PHONY: test
test: $(CONFIG_PATH)/acl-policy.csv $(CONFIG_PATH)/acl-model.conf
	go test -race ./...

.PHONY: compile
compile:
	protoc api/v1/*.proto \
		--go_out=. \
		--go-grpc_out=. \
		--go_opt=paths=source_relative \
		--go-grpc_opt=paths=source_relative \
		--proto_path=.


