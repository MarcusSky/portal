defmodule PortalTest do
  use ExUnit.Case, async: true
  doctest Portal

  setup do
    {:ok, red_pid} = Portal.shoot(:red)
    {:ok, blue_pid} = Portal.shoot(:blue)

    on_exit(fn ->
      DynamicSupervisor.terminate_child(Portal.DynamicSupervisor, red_pid)
      DynamicSupervisor.terminate_child(Portal.DynamicSupervisor, blue_pid)
    end)

    :ok
  end

  describe "transfer" do
    test "adds data to the leftmost portal" do
      Portal.transfer(:red, :blue, [1, 2, 3])

      assert [3, 2, 1] = Portal.Door.get(:red)
      assert [] = Portal.Door.get(:blue)
    end
  end

  describe "push_right/1" do
    test "sends data from the left portal to the right portal" do
      portal = Portal.transfer(:red, :blue, [1, 2, 3])
      Portal.push_right(portal)

      assert [2, 1] = Portal.Door.get(:red)
      assert [3] = Portal.Door.get(:blue)
    end
  end

  describe "push_left/1" do
    test "sends data from the left portal to the right portal" do
      portal = Portal.transfer(:red, :blue, [1, 2, 3])
      Portal.push_right(portal)
      Portal.push_right(portal)
      Portal.push_right(portal)

      Portal.push_left(portal)

      assert [1] = Portal.Door.get(:red)
      assert [2, 3] = Portal.Door.get(:blue)
    end
  end
end
