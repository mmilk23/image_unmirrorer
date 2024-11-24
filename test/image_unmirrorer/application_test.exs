# test\image_unmirrorer\application_test.exs
defmodule ImageUnmirrorer.ApplicationTest do
  use ExUnit.Case

  setup do
    # Ensure the application is stopped before each test
    Application.stop(:image_unmirrorer)
    :ok
  end

  test "application start/2 function works and supervisor is started" do
    # Start the application directly
    {:ok, sup_pid} = ImageUnmirrorer.Application.start(:normal, [])

    # Ensure the supervisor PID is valid and alive
    assert is_pid(sup_pid)
    assert Process.alive?(sup_pid)

    # Get children of the supervisor
    children = Supervisor.which_children(sup_pid)

    # Verify that Plug.Cowboy listener is one of the children
    assert Enum.any?(children, fn {id, _pid, _type, _modules} ->
      id == {:ranch_listener_sup, ImageUnmirrorer.Router.HTTP}
    end)
  end
end
