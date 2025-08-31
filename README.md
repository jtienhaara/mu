# mu

[![Build](https://img.shields.io/github/actions/workflow/status/jtienhaara/mu/build.yaml)](https://github.com/jtienhaara/mu/blob/main/.github/workflows/build.yaml)
[![Release](https://img.shields.io/github/v/release/jtienhaara/mu)](https://github.com/jtienhaara/mu/releases)

[![License](https://img.shields.io/github/license/jtienhaara/mu)](https://github.com/jtienhaara/mu/blob/main/LICENSE)

![C](https://img.shields.io/badge/c-%2300599C.svg?style=for-the-badge&logo=c&logoColor=white)
![Valgrind](https://img.shields.io/badge/Valgrind-006094?style=for-the-badge)
![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white)


mu is a programming language in the very very very early stages of experimental development.


## Features

- None.


## Examples

- None.


## Downloading

- You can't.


## Building

- Don't bother trying.


## Dependencies

mu depends on:

- [utf8proc](https://github.com/JuliaStrings/utf8proc) for character handling.
- [pcre2](https://github.com/PCRE2Project/pcre2) for regular expressions.
- [libutf8lex](https://github.com/jtienhaara/utf8lex) for lexing.

When building or using mu, you will need to have these dependencies installed.
For example, on Debian:

```shell
sudo apt-get update
sudo apt-get wget
sudo apt-get install libpcre2-dev libutf8proc-dev libutf8proc2
UTF8LEX_VERSION=0.0.1
UTF8LEX_MAJOR=0
DEBIAN_ARCHITECTURE=`./ci/get_debian_architecture.sh`
sudo wget https://github.com/jtienhaara/utf8lex/releases/download/v${UTF8LEX_VERSION}/libutf8lex.so.${UTF8LEX_VERSION}.$DEBIAN_ARCHITECTURE \
    --output-document /usr/lib/libutf8lex.so.${UTF8LEX_VERSION}
sudo wget https://github.com/jtienhaara/utf8lex/releases/download/v${UTF8LEX_VERSION}/utf8lex.h \
    --output-document /usr/include/utf8lex.h
sudo wget https://github.com/jtienhaara/utf8lex/releases/download/v${UTF8LEX_VERSION}/utf8lex.${UTF8LEX_VERSION}.$DEBIAN_ARCHITECTURE \
    --output-document /usr/bin/utf8lex
sudo chmod a+x \
           /usr/lib/libutf8lex.a.${UTF8LEX_VERSION} \
           /usr/lib/libutf8lex.so.${UTF8LEX_VERSION} \
           /usr/bin/utf8lex
sudo ln -s /usr/lib/libutf8lex.a.${UTF8LEX_VERSION} /usr/lib/libutf8lex.a.${UTF8LEX_MAJOR}
sudo ln -s /usr/lib/libutf8lex.a.${UTF8LEX_VERSION} /usr/lib/libutf8lex.a
sudo ln -s /usr/lib/libutf8lex.so.${UTF8LEX_VERSION} /usr/lib/libutf8lex.so.${UTF8LEX_MAJOR}
sudo ln -s /usr/lib/libutf8lex.so.${UTF8LEX_VERSION} /usr/lib/libutf8lex.so
```

Installing other tools (such as gcc and valgrind) might be useful,
depending on your needs.  See [debian.Dockerfile](debian.Dockerfile),
for example, for the tools and libraries used to build mu.


## Licenses

| Licenses:     |                          |                                   |
|---------------|--------------------------|-----------------------------------|
| mu            | SPDX-License-Identifier: | Apache-2.0                        |
| utf8lex       | SPDX-License-Identifier: | Apache-2.0                        |
| utf8proc      | SPDX-License-Identifier: | MIT                               |
|               | SPDX-License-Identifier: | Unicode-DFS-2016	               |
| pcre2         | SPDX-License-Identifier: | BSD-3-Clause WITH PCRE2-exception |

[utf8lex LICENSE](https://github.com/jtienhaara/utf8lex/blob/main/LICENSE)

[utf8proc LICENSE.md](https://github.com/JuliaStrings/utf8proc/blob/master/LICENSE.md)

[pcre2 LICENSE.md](https://github.com/PCRE2Project/pcre2/blob/master/LICENCE.md)


## TODO

Eventually there will be a [GitHub Issues list](https://github.com/jtienhaara/mu/issues) to track todo items, once a stable release has been created.


## Contact

mu is made by
[Johann Tienhaara](https://github.com/jtienhaara/).
For now (until issues have been set up), bugs, feature requests
and other queries will go through him.
