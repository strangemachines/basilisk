defmodule BasiliskWeb.LocalePlug do
  import Plug.Conn

  require Logger

  alias BasiliskWeb.LocalePlug
  alias Plug.Conn

  @cookies Application.compile_env(:basilisk, :cookies)
  @cookies_options Keyword.get(@cookies, :options, [])
  @locale_cookie_name Keyword.get(@cookies, :locale, "locale")
  @locales Gettext.known_locales(BasiliskWeb.Gettext)

  def init(default_locale), do: default_locale

  def validate(locale) when locale in @locales, do: locale
  def validate(_locale), do: nil

  defp parse_language_option(string) do
    captures = Regex.named_captures(~r/^\s?(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i, string)

    quality =
      case Float.parse(captures["quality"] || "1.0") do
        {val, _} -> val
        _ -> 1.0
      end

    %{tag: captures["tag"], quality: quality}
  end

  defp ensure_language_fallbacks(tags) do
    Enum.flat_map(tags, fn tag ->
      [language | _] = String.split(tag, "-")
      if Enum.member?(tags, language), do: [tag], else: [tag, language]
    end)
  end

  def extract_accept_language(conn) do
    case Plug.Conn.get_req_header(conn, "accept-language") do
      [value | _] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(& &1.tag)
        |> Enum.reject(&is_nil/1)
        |> ensure_language_fallbacks()

      _ ->
        []
    end
  end

  def from_header(conn) do
    conn
    |> LocalePlug.extract_accept_language()
    |> Enum.find(nil, fn accepted_locale -> Enum.member?(@locales, accepted_locale) end)
  end

  def from_params(conn) do
    conn.params["locale"] |> LocalePlug.validate()
  end

  def from_cookies(conn) do
    LocalePlug.validate(conn.cookies[@locale_cookie_name])
  end

  def set_cookie(conn, locale) do
    if conn.cookies[@locale_cookie_name] != locale do
      conn
      |> Conn.put_resp_cookie(@locale_cookie_name, locale, @cookies_options)
    else
      conn
    end
  end

  def set_locale(conn, locale) do
    Logger.debug("Setting locale to #{locale}")
    Gettext.put_locale(BasiliskWeb.Gettext, locale)

    conn
    |> LocalePlug.set_cookie(locale)
    |> put_session("locale", locale)
  end

  def call(conn, _opts) do
    case LocalePlug.from_params(conn) || LocalePlug.from_cookies(conn) ||
           LocalePlug.from_header(conn) do
      nil -> conn
      locale -> LocalePlug.set_locale(conn, locale)
    end
  end
end
