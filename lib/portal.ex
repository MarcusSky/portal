defmodule Portal do
  @moduledoc """
  Documentation for Portal.
  """

  defstruct [:left, :right]

  @doc """
  Shoots a new door with the given `color`.
  """
  @spec shoot(atom) :: {:ok, pid} | {:error, String.t()}
  def shoot(color) do
    DynamicSupervisor.start_child(Portal.DynamicSupervisor, {Portal.Door, color})
  end

  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  @spec transfer(atom, atom, [any()]) :: %Portal{}
  def transfer(left, right, data) do
    # First add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left, item)
    end

    # Returns a portal struct we will use next
    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given `portal`.
  """
  @spec push_right(%Portal{}) :: %Portal{}
  def push_right(portal) do
    move(portal, :right)
  end

  @doc """
  Pushes data to the left in the given `portal`.
  """
  @spec push_left(%Portal{}) :: %Portal{}
  def push_left(portal) do
    move(portal, :left)
  end

  @spec move(%Portal{}, atom) :: %Portal{}
  defp move(portal, direction) do
    push_direction = Map.get(portal, direction)

    pop_direction =
      case direction do
        :left -> portal.right
        :right -> portal.left
      end

    case Portal.Door.pop(pop_direction) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(push_direction, h)
    end

    portal
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.pad_leading(left_door, max)} <=> #{right_door}
      #{String.pad_leading(left_data, max)} <=> #{right_data}
    >
    """
  end
end
