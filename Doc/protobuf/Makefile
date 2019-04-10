all: generate copy

generate:
	protoc --swift_out=. --swift_opt=Visibility=Public dex.proto

copy:
	cp dex.pb.swift ../../BinanceChain/Sources/Protobuf

