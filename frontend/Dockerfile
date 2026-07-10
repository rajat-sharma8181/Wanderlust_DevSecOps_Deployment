# ------------------- Stage 1: Build Stage ------------------------------
FROM node:21 AS frontend-builder

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Bake VITE_API_PATH empty so the built JS calls the API same-origin (/api/...),
# which the ALB Ingress routes to the backend. VITE_* vars are inlined at build
# time, so this must be set here (the runtime env in the Deployment is ignored by
# a static build). Written as .env.production because `vite build` runs in
# production mode; do NOT create .env.local (it would take priority over this).
RUN printf 'VITE_API_PATH=\n' > .env.production

# Produce static assets in /app/dist (tsc + vite build, per package.json).
RUN npm run build

# ------------------- Stage 2: Final Stage (nginx) ----------------------
FROM nginx:alpine

# Replace the default nginx site with the built SPA and our config.
RUN rm -rf /usr/share/nginx/html/*
COPY --from=frontend-builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Serve on 5173 to match the existing Service/Ingress/probes in the Helm chart.
EXPOSE 5173

CMD ["nginx", "-g", "daemon off;"]
