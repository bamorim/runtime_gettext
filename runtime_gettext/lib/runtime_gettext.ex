defmodule RuntimeGettext do
  @moduledoc """
  To enable runtime loading of gettext translation strings, just do:

      use Gettext, otp_app: :your_otp_app
      use RuntimeGettext

  The order is important, `use Gettext` needs to come before `use RuntimeGettext`.

  Then, you need to add translations to the `RuntimeGettext.ETSRepo`
  """

  defmacro __using__(opts \\ []) do
    quote do
      @runtime_gettext_opts unquote(opts)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    opts = Module.get_attribute(env.module, :runtime_gettext_opts)
    gettext_opts = Module.get_attribute(env.module, :gettext_opts)

    repo = opts[:repo] || RuntimeGettext.ETSRepo

    interpolation = gettext_opts[:interpolation] || Gettext.Interpolation.Default

    plural_mod =
      Keyword.get(gettext_opts, :plural_forms) ||
        Application.get_env(:gettext, :plural_forms, Gettext.Plural)

    quote do
      require Gettext.Interpolation.Default
      defoverridable lgettext: 5, lngettext: 7

      def lgettext(locale, domain, msgctxt, msgid, bindings) do
        case unquote(repo).get_translation(locale, domain, msgctxt, msgid) do
          {:ok, msgstr} ->
            unquote(interpolation).runtime_interpolate(msgstr, bindings)

          _ ->
            super(locale, domain, msgctxt, msgid, bindings)
        end
      end

      def lngettext(locale, domain, msgctxt, msgid, msgid_plural, n, bindings) do
        plural_form = unquote(plural_mod).plural(locale, n)

        case unquote(repo).get_plural_translation(
               locale,
               domain,
               msgctxt,
               msgid,
               plural_form
             ) do
          {:ok, msgstr} ->
            bindings = Map.put(bindings, :count, n)
            unquote(interpolation).runtime_interpolate(msgstr, bindings)

          _ ->
            unquote(interpolation).runtime_interpolate(msgid, bindings)
            super(locale, domain, msgctxt, msgid, msgid_plural, n, bindings)
        end
      end
    end
  end
end
