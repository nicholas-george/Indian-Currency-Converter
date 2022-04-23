defmodule InrWordTest do
  use ExUnit.Case
  doctest InrWord

  test "Currency in words" do
    assert InrWord.inr_word(1_000_000_000.99).words ==
             "₹ one hundred crore and ninety-nine paisa"
  end

  test "Currency in numbers" do
    assert InrWord.inr_word(10_000_000).no == "₹ 1,00,00,000"
  end

  test "Custom Rupee prefix" do
    assert InrWord.inr_word(10_000_000, "Rupees") == %{
             no: "Rupees 1,00,00,000",
             words: "Rupees one crore"
           }
  end

  test "Custom Paisa prefix" do
    assert InrWord.inr_word(10_000_000.09, "Rupees", "ps") == %{
             no: "Rupees 1,00,00,000.09",
             words: "Rupees one crore and nine ps"
           }
  end

  test "Recursion for no above 999 cr" do
    assert InrWord.inr_word(1_050_000_000_000.99).words ==
             "₹ one lac five thousand crore and ninety-nine paisa"
  end

  test "The hundred nubers work" do
    assert InrWord.inr_word(999_999_999.09).words ==
             "₹ ninety-nine crore ninety-nine lac ninety-nine thousand nine hundred ninety-nine and nine paisa"
  end

  test "Smaller number" do
    assert InrWord.inr_word(97).no == "₹ 97"
  end
end
