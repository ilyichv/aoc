defmodule TrashCompactor do
  def part_1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> transpose()
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&evaluate/1)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> transpose()
    |> Enum.reverse()
    |> Enum.chunk_by(&is_separator?/1)
    |> Enum.reject(&is_separator?(hd(&1)))
    |> Enum.map(&parse_block/1)
    |> Enum.map(&evaluate/1)
    |> Enum.sum()
  end

  defp parse_block(rows) do
    rows
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.trim/1)
    |> extract_operator_and_numbers()
  end

  defp extract_operator_and_numbers(rows) do
    {operator_row, number_rows} = List.pop_at(rows, -1)
    {number, operator} = String.split_at(operator_row, -1)
    [operator, String.trim(number) | number_rows]
  end

  defp is_separator?(row), do: Enum.all?(row, &(&1 == " "))

  defp evaluate([operator | numbers]) do
    numbers = Enum.map(numbers, &String.to_integer/1)
    apply_operator(operator, numbers)
  end

  defp transpose(rows), do: Enum.zip_with(rows, &Function.identity/1)

  defp apply_operator("+", numbers), do: Enum.sum(numbers)
  defp apply_operator("*", numbers), do: Enum.product(numbers)
end

input = File.read!("2025/inputs/day_6.txt")
result_1 = TrashCompactor.part_1(input)
IO.inspect(result_1, label: "PART 1")
result_2 = TrashCompactor.part_2(input)
IO.inspect(result_2, label: "PART 2")
