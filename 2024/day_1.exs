defmodule HistorianHysteria do
  def part_1(input) do
    input
    |> parse_input()
    |> calculate_total_distance()
  end

  def part_2(input) do
    input
    |> parse_input()
    |> calculate_overlap()
  end

  defp calculate_overlap({left, right}) do
    freq = Enum.frequencies(right)

    Enum.reduce(left, 0, fn digit, acc ->
      acc + digit * Map.get(freq, digit, 0)
    end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], []}, fn line, {left, right} ->
      [a, b] = String.split(line, " ", trim: true)
      {[String.to_integer(a) | left], [String.to_integer(b) | right]}
    end)
    |> then(fn {left, right} -> {Enum.sort(left), Enum.sort(right)} end)
  end

  defp calculate_total_distance({left, right}) do
    Enum.zip_reduce(left, right, 0, fn a, b, acc ->
      acc + abs(a - b)
    end)
  end
end

input = File.read!("2024/inputs/day_1.txt")
result_1 = HistorianHysteria.part_1(input)
IO.inspect(result_1, label: "PART 1")
result_2 = HistorianHysteria.part_2(input)
IO.inspect(result_2, label: "PART 2")
