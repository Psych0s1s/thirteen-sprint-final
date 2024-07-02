# Первый этап: сборка
FROM golang:1.22.1-alpine AS builder

WORKDIR /app

RUN apk add --no-cache build-base

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o main .

# Второй этап: создание минимального образа
FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache libc6-compat sqlite-libs

# Копируем исполняемый файл из первого этапа
COPY --from=builder /app/main .

# Копируем базу данных в контейнер
COPY tracker.db .

CMD ["./main"]
