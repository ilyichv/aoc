defmodule Lobby do
  def solve(input, digits_length) do
    input
    |> Stream.map(&(&1 |> String.to_integer() |> Integer.digits()))
    |> Stream.map(&joltage(&1, digits_length))
    |> Enum.sum()
  end

  defp joltage(_digits, 0), do: 0

  defp joltage(digits, size) do
    window_size = length(digits) - size + 1

    {max_value, max_index} =
      digits
      |> Enum.take(window_size)
      |> Enum.with_index()
      |> Enum.max_by(fn {digit, _index} -> digit end)

    to_check = Enum.drop(digits, max_index + 1)
    max_value * Integer.pow(10, size - 1) + joltage(to_check, size - 1)
  end

  # FIRST UNOPTIMIZED ITERATION
  # defp max_combo(digits, digits_length),
  #   do: combine(digits, digits_length) |> Enum.max()

  # defp combine(digits, n), do: combine(digits, n, 0, [])
  # defp combine(_, 0, acc, res), do: [acc | res]
  # defp combine([], _, _, res), do: res

  # defp combine([digit | tail], n, acc, res),
  # do: combine(tail, n, acc, combine(tail, n - 1, acc * 10 + digit, res))
end

input = File.read!("2025/inputs/day_3.txt") |> String.split("\n", trim: true)
result_1 = Lobby.solve(input, 2)
IO.inspect(result_1, label: "PART 1")
result_2 = Lobby.solve(input, 12)
IO.inspect(result_2, label: "PART 2")
