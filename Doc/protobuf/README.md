To regenerate the protobuf classes:

Install dependencies:
```console
% brew install protobuf swift-protobuf
```

Generate the swift class files:
```console
% protoc --swift_out=. --swift_opt=Visibility=Public dex.proto
```

Copy into the project:
```console
% cp dex.pb.swift ../../BinanceChain/Sources/Core
```
