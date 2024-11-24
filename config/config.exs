#config/config.exs

import Config

# Default Logger configuration
config :logger,
  level: :debug, # Log level: :debug, :info, :warn, or :error
  backends: [:console] # Default backend for logging to the console

# Additional Logger configuration for detailed logging
config :logger, :console,
  format: "$time $metadata[$level] $message\n", # Log format
  metadata: [:request_id] # Metadata to include in logs (add request_id explicitly in Plug if needed)

# Application-specific configurations
config :image_unmirrorer,
  port: 4000 # Port where the server will be started
