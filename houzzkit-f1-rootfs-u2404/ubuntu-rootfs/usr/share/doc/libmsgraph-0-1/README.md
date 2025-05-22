# libmsgraph

libmsgraph is a GLib-based library for accessing online serive APIs using MS Graph protocol.

See the test programs in `src/tests` for simple examples of how to use the code.

## Licensing

libmsgraph is licensed under the LGPL; see COPYING for more details.

## Building

We use the Meson (and thereby Ninja) build system for libmsgraph. The quickest
way to get going is to do the following:

```sh
meson . _build
ninja -C _build
ninja -C _build install
```

For build options see [meson_options.txt](./meson_options.txt). E.g. to enable documentation:

```sh
meson . _build -Dgtk_doc=true
ninja -C _build
```


## Documentation

The documentation can be found online
[here](https://jbrummer.pages.gitlab.gnome.org/msgraph).

## Links

- Microsoft Graph API: https://docs.microsoft.com/en-us/graph/
- API version 1.0 reference: https://docs.microsoft.com/en-us/graph/api/overview?toc=./ref/toc.json&view=graph-rest-1.0
