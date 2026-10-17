FROM nginx:stable-alpine

# Replace the default nginx page with our app
COPY app/ /usr/share/nginx/html/

EXPOSE 80
