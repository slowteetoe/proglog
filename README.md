# Building a log

This is just working through the source code example from the great book "Distributed Services with Go" by Travis Jeffery (<https://pragprog.com/titles/tjgo/distributed-services-with-go/>)

## Building

Must install protoc and grpc packages

Go to <https://github.com/protocolbuffers/protobuf/releases> and grab the protoc package for your platform (e.g. protoc-3.15.6-linux-x86_64.zip if you're using ubuntu).  Install it somewhere, and make sure to add the `bin` folder to your $PATH. If you put it into `/usr/local/protobuf`, then you could add something like the following to your ~/.zshenv

```sh
export PATH="$PATH:/usr/local/protobuf/bin"
```

Install the golang grpc plugin:

```bash
go get google.golang.org/grpc@v1.32.0
go get google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.0.0
```

## Testing

(TODO sort out the Makefile a bit so we don't have to separate into "first time" "every other time")

First time:

```bash
make init
make gencerts
```

Every time:

```bash
make test
```
