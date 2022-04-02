defmodule RuntimeGettextPO do
  @moduledoc """
  `RuntimeGettextPO` helps you populate `RuntimeGettext.ETSRepo` with PO files
  from a directory.

  If you want to load the translations on application boot, you can just add

      RuntimeGettextPO.load_po_files(Application.app_dir(:my_otp_app, "priv/gettext"))

  To your application.
  """

  @po_wildcard "*/LC_MESSAGES/*.po"

  alias RuntimeGettext.ETSRepo
  alias Gettext.PO.Translation
  alias Gettext.PO.PluralTranslation

  @doc """
  Loads all PO files in a given directory following the same directory structure
  as `Gettext` uses by default.
  """
  def load_po_files(translations_dir) do
    for %{locale: locale, domain: domain, path: path} <- known_po_files(translations_dir) do
      load_po_file(locale, domain, path)
    end

    :ok
  end

  @doc """
  Loads a single PO file from a given path assuming a locale and domain.

  It doesnt make any assumption of structure so you need to specify locale and
  domain.
  """
  def load_po_file(locale, domain, path) do
    parsed = Gettext.PO.parse_file!(path)

    for translation <- parsed.translations do
      add_po_translation(locale, domain, translation)
    end
  end

  defp add_po_translation(locale, domain, %Translation{
         msgctxt: msgctxt,
         msgid: msgid,
         msgstr: msgstr
       }) do
    ETSRepo.add_translation(
      locale,
      domain,
      msgctxt && IO.iodata_to_binary(msgctxt),
      IO.iodata_to_binary(msgid),
      IO.iodata_to_binary(msgstr)
    )
  end

  defp add_po_translation(locale, domain, %PluralTranslation{
         msgctxt: msgctxt,
         msgid: msgid,
         msgstr: msgstr
       }) do
    for {form, msgstr} <- msgstr do
      ETSRepo.add_plural_translation(
        locale,
        domain,
        msgctxt && IO.iodata_to_binary(msgctxt),
        IO.iodata_to_binary(msgid),
        form,
        IO.iodata_to_binary(msgstr)
      )
    end
  end

  # Functions copied from Gettext.Compiler
  # Maybe we could extract into a code that is easily shared
  defp known_po_files(translations_dir) do
    case File.ls(translations_dir) do
      {:ok, _} ->
        translations_dir
        |> po_files_in_dir()
        |> Enum.map(fn path ->
          {locale, domain} = locale_and_domain_from_path(path)
          %{locale: locale, path: path, domain: domain}
        end)

      {:error, :enoent} ->
        []

      {:error, reason} ->
        raise File.Error, reason: reason, action: "list directory", path: translations_dir
    end
  end

  defp locale_and_domain_from_path(path) do
    [file, "LC_MESSAGES", locale | _rest] = path |> Path.split() |> Enum.reverse()
    domain = Path.rootname(file, ".po")
    {locale, domain}
  end

  defp po_files_in_dir(dir) do
    dir
    |> Path.join(@po_wildcard)
    |> Path.wildcard()
  end
end
