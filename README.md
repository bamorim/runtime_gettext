# Runtime Gettext

This repository contains a few projects to allow gettext to run in runtime:

- `runtime_gettext`
  - Defines a macro to plug into the generated `use Gettext` functions to first check for a runtime translation string
  - It also defines a behavior `RuntimeGettext.Repo` and a default implementation using `RuntimeGettext.ETSRepo` that gets translation strings from an ETS table.
  - It also starts `RuntimeGettext.ETSRepo` by default (which creates the ETS table and starts the genserver for setting translations)
- `runtime_gettext_po`
  - Contains functions to load translations from `po` files and save them to the `RuntimeGettext.ETSRepo`
- `rg_demo`
  - A demo phoenix application to show how that would work