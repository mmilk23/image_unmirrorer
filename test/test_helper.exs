# test\test_helper.exs
ExUnit.start(formatters: [ExUnitFormatterHTML])

# Define the mock for Image.Behaviour
Mox.defmock(ImageMock, for: Image.Behaviour)

# Set Mox to use context-based mocking
Mox.set_mox_from_context([])

# Configure the application to use the mock during tests
Application.put_env(:image_unmirrorer, :image_module, ImageMock)
