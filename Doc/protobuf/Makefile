all: gen cp

gen:
	protoc --swift_out=. dex.proto

cp:
	cp dex.pb.swift ../../BinanceChain/Sources/Core

