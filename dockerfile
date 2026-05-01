# Étape 1 : Construction (Inchangée mais optimisée)
FROM golang:1.25-alpine AS builder 
WORKDIR /app
COPY go.mod ./
RUN go mod download || true
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Étape 2 : Image finale ultra-légère et sécurisée
FROM gcr.io/distroless/static:latest
WORKDIR /

# On copie les fichiers avec les bons droits (propriétaire nonroot)
COPY --from=builder --chown=nonroot:nonroot /app/main .
COPY --from=builder --chown=nonroot:nonroot /app/index.html .
COPY --from=builder --chown=nonroot:nonroot /app/index.js .
COPY --from=builder --chown=nonroot:nonroot /app/style.css .

# --- LA TOUCHE SÉCURITÉ ---
# On bascule sur l'utilisateur non-privilégié
USER nonroot:nonroot

EXPOSE 8080
# On lance le binaire directement (sans shell, impossible de faire des injections de commandes)
ENTRYPOINT ["./main"]