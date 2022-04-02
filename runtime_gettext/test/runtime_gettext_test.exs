defmodule RuntimeGettextTest do
  use ExUnit.Case, async: false
  doctest RuntimeGettext

  alias RuntimeGettext.ETSRepo

  setup do
    :ets.delete_all_objects(ETSRepo)
    :ok
  end

  test "we can change translation in runtime" do
    locale = "pt"
    domain = "default"
    msgctxt = nil
    msgid = "Welcome to %{name}!"
    msgstr = "Set on runtime %{name}!"

    assert :ok = ETSRepo.add_translation(locale, domain, msgctxt, msgid, msgstr)

    assert {:ok, "Set on runtime Test!"} =
             DemoGettext.lgettext(locale, domain, msgctxt, msgid, %{name: "Test"})
  end

  test "uses compile time code if no translation is found" do
    locale = "pt"
    domain = "default"
    msgctxt = nil
    msgid = "Welcome to %{name}!"

    assert {:default, "Welcome to Test!"} =
             DemoGettext.lgettext(locale, domain, msgctxt, msgid, %{name: "Test"})
  end
end
