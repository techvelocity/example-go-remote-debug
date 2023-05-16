FROM golang:1.18 AS build
WORKDIR /
COPY . .
RUN CGO_ENABLED=0 go install github.com/go-delve/delve/cmd/dlv@latest
RUN CGO_ENABLED=0 go build -gcflags "all=-N -l" -o ./app

FROM alpine
WORKDIR /
COPY . .
COPY --from=build /go/bin/dlv dlv
COPY --from=build /app app
ENTRYPOINT [ "/dlv" , "--listen=:40000", "--headless=true", "--api-version=2", "--accept-multiclient", "exec", "/app"]
