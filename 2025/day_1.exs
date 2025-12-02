# PART 1
defmodule SecretEntrancePart1 do
  @start 50

  def solve(input) do
    Enum.reduce(
      input,
      {@start, 0},
      fn step, {pos, count} ->
        case move(pos, step) do
          0 -> {0, count + 1}
          new_pos -> {new_pos, count}
        end
      end
    )
  end

  defp move(current, "L" <> distance), do: Integer.mod(current - String.to_integer(distance), 100)
  defp move(current, "R" <> distance), do: Integer.mod(current + String.to_integer(distance), 100)
end

# PART 2
defmodule SecretEntrancePart2 do
  @start 50

  def solve(input) do
    input
    |> Enum.reduce(
      {@start, 0},
      fn step, {position, count} ->
        {direction, distance} = parse(step)
        new_position = move(direction, position, distance)
        new_count = count + count_crossings(direction, position, distance)
        {new_position, new_count}
      end
    )
  end

  defp parse("L" <> distance), do: {:left, String.to_integer(distance)}
  defp parse("R" <> distance), do: {:right, String.to_integer(distance)}

  defp move(:left, current, distance), do: Integer.mod(current - distance, 100)
  defp move(:right, current, distance), do: Integer.mod(current + distance, 100)

  defp count_crossings(:left, 0, distance), do: div(distance, 100)
  defp count_crossings(:left, current, distance), do: div(100 - current + distance, 100)
  defp count_crossings(:right, current, distance), do: div(distance + current, 100)
end

input = File.read!("2025/inputs/day_1.txt") |> String.split("\n")
{_pos, password_part_1} = SecretEntrancePart1.solve(input)
IO.inspect(password_part_1, label: "PART 1")
{_pos, password_part_2} = SecretEntrancePart2.solve(input)
IO.inspect(password_part_2, label: "PART 2")
