# STAGE 1: Build app
# Step 1: Pull node offical image
FROM node:6.9.1-alpine as builder
# Step 2: Define working dir for builder container
WORKDIR /usr/local/app
# Step 3: Copy package.json and package-lock.json files
COPY package*.json ./
# Step 4: Install dependancy
RUN npm cache clean --force
RUN rm -rf node_modules
RUN npm install -g @angular/cli
RUN npm install
# Step 5: Copy all source code
COPY . .
# Step 6: Generate build of application
RUN ng build --configuration=production --source-map=false
# STAGE 2: Setup Server
# Step 7: Pull nginx image
FROM nginx:1.21.5-alpine
# Step 8: Copy default nginx config
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
# Step 9: Copy builded application source code
COPY --from=builder /usr/local/app/dist/bank-app-ui /usr/share/nginx/html
# step 10: Expose container port 80
EXPOSE 4200
# Step 11: Switch nginx deamon off
# Note: If your container serve multiple service than don't daemon off.
CMD nginx -g "daemon off;"
