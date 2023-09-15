FROM golang:1.21.0

WORKDIR /app

ADD ./app/ /app/src/
RUN go build -o /app/main /app/src/main.go

CMD ["/app/main"]
