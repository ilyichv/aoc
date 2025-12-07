defmodule RedNosedReports do
  def part_1(input) do
    input
    |> parse_input()
    |> Enum.count(&safe?/1)
  end

  def part_2(input) do
    input
    |> parse_input()
    |> Enum.count(&safe?(&1, true))
  end

  defp safe?(report, with_dampener \\ false) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce_while(nil, fn [a, b], prev_direction ->
      diff = b - a
      direction = if diff > 0, do: :asc, else: :desc

      cond do
        abs(diff) not in 1..3 -> {:halt, :unsafe}
        prev_direction not in [nil, direction] -> {:halt, :unsafe}
        true -> {:cont, direction}
      end
    end)
    |> case do
      :unsafe when with_dampener ->
        0..(length(report) - 1)
        |> Enum.any?(fn index ->
          report |> List.delete_at(index) |> safe?(false)
        end)

      :unsafe ->
        false

      _ ->
        true
    end
  end

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn report ->
      report |> String.split(" ") |> Enum.map(&String.to_integer/1)
    end)
  end
end

input = File.read!("2024/inputs/day_2.txt")
result_1 = RedNosedReports.part_1(input)
IO.inspect(result_1, label: "PART 1")
result_2 = RedNosedReports.part_2(input)
IO.inspect(result_2, label: "PART 2")
