# config/test.exs
use Mix.Config

# Configure the mock for the Image module during tests
config :image_unmirrorer, :image_module, ImageMock
