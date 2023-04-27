# Use the official Node.js image as the base image
FROM --platform=linux/amd64 node:16-alpine
# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm ci --only=production

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port that the API is running on
EXPOSE 4300

# Start the API
ENTRYPOINT ["npm", "start"]
