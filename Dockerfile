### Dockerfile
# Use the official Elixir image as a base
FROM elixir:1.18

# Install dependencies and prepare for the release
RUN mix local.hex --force && \
    mix local.rebar --force

# Set the working directory
WORKDIR /app

# Copy the mix files and install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy the rest of the application files
COPY . .

# Compile the project
RUN mix compile

# Expose port 4000
EXPOSE 4000

# Command to run the application
CMD ["mix", "run", "--no-halt"]