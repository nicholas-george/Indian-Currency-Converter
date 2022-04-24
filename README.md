# InrWord
[![Elixir CI](https://github.com/nicholas-george/Indian-Currency-Converter/actions/workflows/elixir.yml/badge.svg)](https://github.com/nicholas-george/Indian-Currency-Converter/actions/workflows/elixir.yml)

An elixir utility to convert numbers into Indian currency.

## Use

If you want to just play around, copy / paste the whole code from lib/inr_word.ex into iex. Then in iex
```elixir
iex> InrWord.inr_word(90000000)
%{no: "₹ 9,00,00,000", words: "₹ Nine crore"}

iex> InrWord.inr_word(90000000.09)
%{no: "₹ 9,00,00,000.09", words: "₹ Nine crore and nine paisa"}

iex> InrWord.inr_word(90000000, "Rs.")
%{no: "Rs. 9,00,00,000", words: "Rs. Nine crore"}

iex> InrWord.inr_word(90000000.09, "Rupees.")
%{no: "Rupees. 9,00,00,000.09", words: "Rs. Nine crore and nine paisa"}

iex> InrWord.inr_word(90000000.09, "Rs.", "Ps.")
%{no: "Rs. 9,00,00,000.09", words: "Rs. Nine crore and nine Ps."}

iex> InrWord.inr_word(90000000.09, "", "")
%{no: "9,00,00,000.09", words: "Nine crore and nine"}

iex> InrWord.inr_word("abc")
%{error: "Not a number."}
```

You can also use it as a module, in your projects as it is.

## Installation

The package can be installed by adding `inr_word` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:inr_word, "~> 0.1.0"}
  ]
end
```

The docs can be found at <https://hexdocs.pm/inr_word>.

## Why another currency converter?

Most international currency handlers split numbers in three digit parts. The larger ones turn into million, billion, trillion etc. But the Indian currency is split into 3 digit -> hundred, 2 digit -> thousand and 2 digit - lacs. Beyond this it is in crores. And there is no eqivalent of billion, trillion etc. 

  For example, 
  a number like '9999999999999999' becomes "₹ 9,99,99,999,99,99,999"
  And in words, "₹ Nine crore ninety-nine lac ninety-nine thousand nine hundred ninety-nine crore ninety-nine lac ninety-nine thousand nine hundred ninety-nine"

Did not find anything in the open source and in Elixir. Also since the code is not large (109 lines) this may be useful for a Elixir beginner to learn things that I learnt doing this project -- recursion, pattern matching, Enum, Map, String....

## Copyright and License

Copyright (c) 2022 Nicholas George

This work is free. You can redistribute it and/or modify it under the terms of the MIT License. See the [LICENSE.md](https://github.com/nicholas-george/Indian-Currency-Converter/blob/master/LICENSE) file for more details.