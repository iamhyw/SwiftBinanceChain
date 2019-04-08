all: gen cp

gen:
	protoc --swift_out=. --swift_opt=Visibility=Public dex.proto

cp:
	cp dex.pb.swift ../../BinanceChain/Sources/Core

