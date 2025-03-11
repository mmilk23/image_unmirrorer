#lib\image_unmirrorer\image_behaviour.ex
defmodule Image.Behaviour do
  @moduledoc """
  Defines behaviors for image operations, such as converting from binary,
  flipping an image, and writing image data.

  This module provides an interface that should be implemented by any module
  that wants to manipulate images, ensuring a consistent approach for
  reading, manipulating, and writing images.
  """

  @callback from_binary(binary()) :: {:ok, any()} | {:error, term()}
  @callback flip(any(), atom()) :: {:ok, any()} | {:error, term()}
  @callback grayscale(any(), atom()) :: {:ok, any()} | {:error, term()}
  @callback write(any(), atom(), keyword()) :: {:ok, binary()} | {:error, term()}
end
