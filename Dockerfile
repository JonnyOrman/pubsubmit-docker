FROM golang:1.18-alpine AS builder

RUN apk update && apk add alpine-sdk git && rm -rf /var/cache/apk/*
RUN mkdir pubsubmit
WORKDIR /pubsubmit
COPY go.mod .
COPY go.sum .
COPY main.go .
RUN go mod download
RUN go build -o ./pubsubmit ./main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder ./pubsubmit ./
EXPOSE 8080
ENTRYPOINT ["./pubsubmit"]