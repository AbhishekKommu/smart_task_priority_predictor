# ---- Build stage ----
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter create . --platforms=web && flutter pub get && flutter build web --release

# ---- Serve stage ----
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
