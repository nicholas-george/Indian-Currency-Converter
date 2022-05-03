defmodule RWord do
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
  @sub_twenty ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"] ++
                ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen"] ++
                ["seventeen", "eighteen", "nineteen"]
  @tens ["", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy"] ++
          ["eighty", "ninety"]
  @curr_map [["lac", 100_000], ["thousand", 1000], ["hundred", 100]]
  @digit_map [thousand: 2, lac: 2, hundred: 3]

  def inr_word(n), do: inr_word(n, "₹", "paisa")

  def inr_word(n, rs, paisa \\ "paisa") do
    if is_number(n) do
      left = trunc(n)
      right = ((n - left) * 100) |> round
      paisa = if byte_size(paisa) > 0, do: " " <> paisa, else: ""
      l_str = get_inr_words(left)
      r_str = if right === 0, do: "", else: " and " <> get_no_str(right) <> paisa
      pad_str = to_string(right) |> String.pad_leading(2, "0")
      r_no = if right === 0, do: "", else: "." <> pad_str
      rs_str = rs <> if byte_size(rs) > 0, do: " ", else: ""
      l_str = l_str |> Enum.with_index(1)
      count = Enum.count(l_str)
      final = get_final(l_str, count)

      %{
        final
        | no: rs_str <> final[:no] <> r_no,
          words: rs_str <> String.trim(String.capitalize(final[:words])) <> r_str
      }
    else
      %{error: "Not a number."}
    end
  end

  defp get_final(l_str, count) do
    Enum.reduce(l_str, %{no: "", words: ""}, fn {unit, i}, acc ->
      new_no = (i === 1 && clean_str(unit[:no])) || String.trim(unit[:no])
      new_word = ((byte_size(acc[:words]) > 0 && " ") || "") <> clean_str(unit[:words])

      %{
        acc
        | no: acc[:no] <> new_no <> ((i < count && ",") || ""),
          words: acc[:words] <> new_word <> ((i < count && " crore") || "")
      }
    end)
  end

  def get_inr_words(n) do
    cr_blocks =
      Integer.digits(n)
      |> Enum.reverse()
      |> Enum.chunk_every(7)
      |> Enum.reverse()
      |> Enum.map(fn x -> Enum.reverse(x) end)
      |> Enum.map(fn x -> String.to_integer(Enum.join(x)) end)

    Enum.map(cr_blocks, fn x ->
      Enum.reduce(@curr_map, %{rem: x, no: "", words: ""}, fn [ord, val], acc ->
        y(acc, ord, val)
      end)
    end)
  end

  def y(acc, ord, val) do
    value = div(acc.rem, val)
    reminder = rem(acc.rem, val)
    [no_str, word_str] = get_parts(value, ord, reminder)

    %{acc | rem: reminder}
    |> Map.update!(:no, fn x ->
      if(byte_size(x) > 0 and value === 0, do: no_str, else: "")
      x <> if(byte_size(x) > 0, do: ",", else: "") <> no_str
    end)
    |> Map.update!(:words, fn x -> x <> word_str end)
  end

  def clean_str(w) do
    case String.starts_with?(w, ["0", ","]) do
      true -> clean_str(String.slice(w, 1, byte_size(w)))
      false -> String.trim(w)
    end
  end

  def get_parts(value, ord, rem) do
    digits = @digit_map[String.to_atom(ord)]
    val_str = to_string(value)

    case {rem, ord} do
      {0, "hundred"} ->
        [String.pad_trailing(val_str, digits, "0"), get_no_str(value, ord)]

      {rem, "hundred"} ->
        n_str =
          if value === 0,
            do: String.pad_leading(to_string(rem), 3, "0"),
            else:
              String.pad_leading(val_str <> String.pad_leading(to_string(rem), 2, "0"), 3, "0")

        [
          n_str,
          # get_no_str(value, ord) <> " " <> get_no_str(rem, "")
          get_no_str(value, ord) <> get_no_str(rem, "")
        ]

      {_, _} ->
        [String.pad_leading(val_str, digits, "0"), get_no_str(value, ord)]
    end
  end

  def get_no_str(n, ord \\ "") do
    ord = if byte_size(ord) > 0, do: " " <> ord <> " ", else: ""

    cond do
      n in 0..19 ->
        if n === 0, do: "", else: Enum.at(@sub_twenty, n) <> ord

      n in 20..99 ->
        format_num(n, 10, "") <> ord
    end
  end

  def format_num(n, div, order) do
    case {div(n, div), rem(n, div), order} do
      {upper, lower, ""} ->
        tens = Enum.at(@tens, upper)
        ones = if lower > 0 and byte_size(tens) > 0, do: "-" <> get_no_str(lower), else: ""
        tens <> ones

      {upper, 0, order} ->
        get_no_str(upper) <> " " <> order

      {upper, lower, order} ->
        get_no_str(upper) <> " " <> order <> " " <> get_no_str(lower)
    end
  end
end
