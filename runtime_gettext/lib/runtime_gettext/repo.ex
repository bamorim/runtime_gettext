defmodule RuntimeGettext.Repo do
  @moduledoc """
  A module that implements this behaviour loads translation strings.

  See `RuntimeGettext.ETSRepo` for an example.
  """

  @type locale() :: binary()
  @type domain() :: binary()
  @type msgctxt() :: binary() | nil
  @type msgid() :: binary()
  @type plural_form() :: integer()
  @type msgstr() :: binary()

  @doc """
  Should return a singular translation string.
  """
  @callback get_translation(locale(), domain(), msgctxt(), msgid()) ::
              {:ok, msgstr()} | {:error, :translation_not_found}

  @doc """
  Should return a plural translation string.
  """
  @callback get_plural_translation(locale(), domain(), msgctxt(), msgid(), plural_form()) ::
              {:ok, msgstr()} | {:error, :translation_not_found}
end
