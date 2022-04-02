defmodule RuntimeGettext.ETSRepoTest do
  use ExUnit.Case, async: false

  alias RuntimeGettext.ETSRepo

  setup do
    :ets.delete_all_objects(ETSRepo)
    :ok
  end

  # TODO: Make tests more isolated by checking the result on the ETS table
  # instead of calling the other methods.

  describe "add_translation/5" do
    test "it loads a singular translation" do
      locale = "pt"
      domain = "default"
      msgctxt = nil
      msgid = "Welcome to %{name}!"
      msgstr = "Bemvindo(a) à %{name}!"

      assert :ok = ETSRepo.add_translation(locale, domain, msgctxt, msgid, msgstr)

      assert {:ok, ^msgstr} = ETSRepo.get_translation(locale, domain, msgctxt, msgid)
    end
  end

  describe "add_plural_translation/6" do
    test "it loads a plural translation" do
      locale = "pt"
      domain = "default"
      msgctxt = nil
      msgid = "There is one number!"
      form = 0
      msgstr = "Aqui tem um número!"

      assert :ok = ETSRepo.add_plural_translation(locale, domain, msgctxt, msgid, form, msgstr)

      assert {:ok, ^msgstr} = ETSRepo.get_plural_translation(locale, domain, msgctxt, msgid, form)
    end
  end

  describe "get_translation/5" do
    test "it returns translation not found when no translation" do
      locale = "pt"
      domain = "default"
      msgctxt = nil
      msgid = "Welcome to %{name}!"

      assert {:error, :translation_not_found} = ETSRepo.get_translation(locale, domain, msgctxt, msgid)
    end

    test "it returns translation not found for empty translation" do
      locale = "pt"
      domain = "default"
      msgctxt = nil
      msgid = "Welcome to %{name}!"
      msgstr = ""

      assert :ok = ETSRepo.add_translation(locale, domain, msgctxt, msgid, msgstr)

      assert {:error, :translation_not_found} = ETSRepo.get_translation(locale, domain, msgctxt, msgid)
    end
  end
end
