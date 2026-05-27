FROM --platform=$BUILDPLATFORM golang:1.26.3-alpine AS build

WORKDIR /app

RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,target=. \
    CGO_ENABLED=0 go build -ldflags="-s" -trimpath -o /bin/server .

FROM gcr.io/distroless/static-debian13:nonroot

COPY --from=build /bin/server /bin/

EXPOSE 8080

ENTRYPOINT ["/bin/server"]
