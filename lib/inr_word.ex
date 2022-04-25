defmodule InrWord do
  @moduledoc """
  Provides a function `inr_word` to to convert any number and return a map with no and words as keys
  Takes three params. the second and third are optional and default to "₹" for rupee and "paisa' for paisa"
    # Example

      iex(1)> InrWord.inr_word(70_000_000_000_000.99) # adds defaults "₹" & "paisa"
      %{
        no: "₹ 70,00,000,00,00,000.99",
        words: "₹ Seventy lac crore and ninety-nine paisa"
      }

      iex(1)> InrWord.inr_word(70_000_000_000_000.99, "Rs.") # adds defaults "paisa"
      %{
        no: "Rs. 70,00,000,00,00,000.99",
        words: "Rs. Seventy lac crore and ninety-nine paisa"
      }

      iex(1)> InrWord.inr_word(70_000_000_000_000.99, "Rs.", "")
      %{
        no: "Rs. 70,00,000,00,00,000.99",
        words: "Rs. Seventy lac crore and ninety-nine"
      }

      iex(1)> InrWord.inr_word(70_000_000_000_000.99, "", "") # No defaults applied
      %{
        no: "70,00,000,00,00,000.99",
        words: "Seventy lac crore and ninety-nine"
      }
  """
  @ones ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"] ++
          ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen"] ++
          ["seventeen", "eighteen", "nineteen"]
  @tens ["zero", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy"] ++
          ["eighty", "ninety"]
  @doc """
    # A Function to add default values and calll 'inr_word/3'
  """
  def inr_word(num), do: inr_word(num, "₹", "paisa")
  @spec inr_word(number, any, any) :: map
  @doc """
    # Converts a given number into both number and word strings.
  """
  def inr_word(num, rs, paisa \\ "paisa") do
    if is_number(num) do
      left = trunc(num)
      right = ((num - left) * 100) |> round
      l_str = get_inr_words(left)
      l_str = %{l_str | words: String.capitalize(l_str[:words])}
      rs_str = rs <> if byte_size(rs) > 0, do: " ", else: ""
      l_str = %{l_str | no: rs_str <> l_str[:no], words: rs_str <> l_str[:words]}

      if right > 0, do: get_right(l_str, right, paisa, left), else: l_str
    else
      %{error: "Not a number."}
    end
  end

  defp get_inr_words(no) do
    Integer.digits(no)
    |> Enum.reverse()
    |> Enum.chunk_every(7)
    |> Enum.map(fn x -> get_grps(x) end)
    |> Enum.map(fn x -> get_full_str(x) end)
    |> package()
  end

  defp get_right(l_str, right, paisa, left) do
    r_str = get_inr_words(right)
    r_no = "." <> String.pad_leading(r_str[:no], 2, "0")
    sep = if left == 0, do: "", else: " and "
    paisa_str = if byte_size(paisa) > 0, do: " " <> paisa, else: ""
    r_words = sep <> r_str[:words] <> paisa_str
    %{l_str | no: l_str[:no] <> r_no, words: l_str[:words] <> r_words}
  end

  defp get_grps(n) do
    Enum.with_index(n, 1)
    |> Enum.reduce(%{}, fn {n, i}, acc ->
      cond do
        i < 4 -> Map.update(acc, :hundred, [n], fn value -> [n | value] end)
        i < 6 -> Map.update(acc, :thousand, [n], fn value -> [n | value] end)
        true -> Map.update(acc, :lac, [n], fn value -> [n | value] end)
      end
    end)
  end

  defp get_full_str(map) do
    Enum.reduce([:lac, :thousand, :hundred], %{no: "", words: ""}, fn ord, acc ->
      ord_val = Map.get(map, ord)
      if ord_val !== nil, do: update_acc(acc, ord, ord_val), else: acc
    end)
  end

  defp update_acc(acc, ord, ord_val) do
    sep = if byte_size(acc[:no]) > 0, do: ",", else: ""
    ord_val_str = ord_val |> Enum.reduce("", fn x, c -> c <> to_string(x) end)
    ord_val_str = sep <> ord_val_str
    ord_val = ord_val |> Enum.join() |> Integer.parse() |> elem(0)
    acc = %{acc | no: acc[:no] <> ord_val_str}
    ord_str = if ord !== :hundred, do: to_string(ord), else: ""

    if ord_val > 0,
      do: %{acc | words: acc[:words] <> get_no_str(ord_val, ord_str)},
      else: acc
  end

  defp package(map) do
    map
    |> Enum.with_index()
    |> Enum.reduce(%{no: "", words: ""}, fn {x, i}, acc ->
      ins_no = x[:no] <> if i > 0, do: ",", else: ""

      ins_words =
        String.trim(x[:words]) <>
          if i > 0 do
            " crore" <> if(byte_size(Enum.at(map, i - 1)[:words]) > 0, do: " ", else: "")
          else
            ""
          end

      %{acc | no: ins_no <> acc[:no], words: ins_words <> acc[:words]}
    end)
  end

  defp get_no_str(n, ord \\ "") do
    ord = if byte_size(ord) > 0, do: " " <> ord <> " ", else: ""

    cond do
      n in 0..19 -> Enum.at(@ones, n) <> ord
      n in 20..99 -> format_num(n, 10, "") <> ord
      n in 100..999 -> format_num(n, 100, "hundred") <> ord
    end
  end

  defp format_num(n, div, order) do
    case {div(n, div), rem(n, div), order} do
      {upper, lower, ""} ->
        tens = Enum.at(@tens, upper)
        ones = if lower > 0, do: "-" <> get_no_str(lower), else: ""
        tens <> ones

      {upper, 0, order} ->
        get_no_str(upper) <> " " <> order

      {upper, lower, order} ->
        get_no_str(upper) <> " " <> order <> " " <> get_no_str(lower)
    end
  end
end
