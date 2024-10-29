# Use Node.js as the base image
FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose the backend port
EXPOSE 8080

# Run the application
CMD ["npm", "start"]
