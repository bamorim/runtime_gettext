defmodule RuntimeGettext.ETSRepo do
  use GenServer

  alias RuntimeGettext.Repo

  @behaviour Repo

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Public API
  @doc """
  Adds a new singular translation
  """
  @spec add_translation(Repo.locale(), Repo.domain(), Repo.msgctxt(), Repo.msgid(), Repo.msgstr()) ::
          :ok
  def add_translation(locale, domain, msgctxt, msgid, msgstr) do
    id = {:translation, locale, domain, msgctxt, msgid}
    GenServer.call(__MODULE__, {:add_translation, id, msgstr})
  end

  @doc """
  Adds a new plural translation
  """
  @spec add_plural_translation(
          Repo.locale(),
          Repo.domain(),
          Repo.msgctxt(),
          Repo.msgid(),
          Repo.plural_form(),
          Repo.msgstr()
        ) ::
          :ok
  def add_plural_translation(locale, domain, msgctxt, msgid, form, msgstr) do
    id = {:plural_translation, locale, domain, msgctxt, msgid, form}
    GenServer.call(__MODULE__, {:add_translation, id, msgstr})
  end

  @impl RuntimeGettext
  def get_translation(locale, domain, msgctxt, msgid) do
    id = {:translation, locale, domain, msgctxt, msgid}
    get_translation_by_id(id)
  end

  @impl RuntimeGettext
  def get_plural_translation(locale, domain, msgctxt, msgid, form) do
    id = {:plural_translation, locale, domain, msgctxt, msgid, form}
    get_translation_by_id(id)
  end

  @doc false
  @impl GenServer
  def init(_opts) do
    create_table()
    {:ok, []}
  end

  defp create_table do
    :ets.new(__MODULE__, [:set, :public, :named_table])
  end

  @doc false
  @impl GenServer
  def handle_call({:add_translation, id, msgstr}, _from, state) do
    true = :ets.insert(__MODULE__, {id, msgstr})
    {:reply, :ok, state}
  end

  defp get_translation_by_id(id) do
    case :ets.lookup(__MODULE__, id) do
      [{_id, ""}] -> {:error, :translation_not_found}
      [{_id, msgstr}] when is_binary(msgstr) -> {:ok, msgstr}
      _ -> {:error, :translation_not_found}
    end
  end
end
