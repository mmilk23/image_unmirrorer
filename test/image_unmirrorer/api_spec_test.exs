#test\image_unmirrorer\api_spec_test.ex
defmodule ImageUnmirrorer.ApiSpecTest do
  use ExUnit.Case

  alias ImageUnmirrorer.ApiSpec

  test "loads the OpenAPI specification" do
    assert %OpenApiSpex.OpenApi{} = ApiSpec.spec()
  end
end
