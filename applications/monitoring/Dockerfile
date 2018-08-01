FROM golang:1.10.3 as builder

RUN go get -u github.com/golang/dep/cmd/dep 

ADD src /go/src/app
WORKDIR /go/src/app
RUN dep init .
RUN go build -a --ldflags '-extldflags "-static"' -tags netgo -installsuffix netgo -o app .

FROM alpine:3.5
COPY --from=builder /go/src/app/app /app/app
CMD /app/app