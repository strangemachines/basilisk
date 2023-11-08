defmodule Basilisk.Internationalization do
  @languages %{
    "en" => "english"
  }

  def languages(), do: @languages

  def language(locale), do: @languages[locale]

  def languages_for_locales() do
    @languages
    |> Enum.reduce([], fn {locale, language}, acc ->
      [{language, locale} | acc]
    end)
  end
end
