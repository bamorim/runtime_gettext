defmodule RuntimeGettextPOTest do
  use ExUnit.Case, async: false

  alias RuntimeGettext.ETSRepo

  setup do
    # TODO: Maybe RuntimeGettext.ETSRepo should have a "clear" function
    :ets.delete_all_objects(ETSRepo)
    :ok
  end

  test "it loads all po files from a path" do
    path = Path.join(__DIR__, "fixtures/gettext")

    assert :ok = RuntimeGettextPO.load_po_files(path)

    assert {:ok, "Bemvindo(a) à %{name}!"} =
             ETSRepo.get_translation("pt", "default", nil, "Welcome to %{name}!")

    assert {:ok, "Isso é um subtítulo."} =
             ETSRepo.get_translation("pt", "other", nil, "This is a subtitle!")

    assert {:ok, "Aqui tem um número!"} =
             ETSRepo.get_plural_translation(
               "pt",
               "default",
               nil,
               "There is one number!",
               0
             )

    assert {:ok, "Aqui tem muitos números"} =
             ETSRepo.get_plural_translation(
               "pt",
               "default",
               nil,
               "There is one number!",
               1
             )
  end
end
