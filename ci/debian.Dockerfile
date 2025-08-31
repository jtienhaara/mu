#
# mu
# Copyright © 2025 Johann Tienhaara
# All rights reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# @version Last updated 2025-08-31
# Debian Bookworm (Debian 12)
# Image from:
#
#     https://hub.docker.com/_/debian
#
FROM debian:12.11-slim

#
# Docker's builtin TARGETARCH build arg:
#
#     https://docs.docker.com/engine/reference/builder/?_gl=1*13mno0d*_ga*NjYxNDI5MzM5LjE2OTQxMDIzNzI.*_ga_XJWPQMJYHQ*MTY5NDQ1MzA1OS4yLjEuMTY5NDQ1MzI4Ny4yOC4wLjA.#automatic-platform-args-in-the-global-scope
#
ARG TARGETARCH

#
# Valgrind platform, for checking for memory leaks etc on most platforms.
# Platforms supported by valgrind:
#   https://valgrind.org/info/platforms.html
#
# TARGETARCH          VALGRIND_PLATFORM
# ------------------- -------------------
# i386                X86/Linux (maintenance)
# ---                 X86/Android
# ---                 X86/Darwin
# ---                 X86/FreeBSD
# ---                 X86/illumos
# ---                 X86/Solaris
# amd64               AMD64/Linux
# ---                 AMD64/FreeBSD
# ---                 AMD64/illumos
# ---                 AMD64/FreeBSD
# ---                 AMD64/Solaris
# arm32v5             ---
# ---                 ---
# arm32v7             ARM/Linux
# ---                 ARM/Android
# arm64v8             ARM64/Linux
# ---                 ARM64/Android
# ---                 ARM64/FreeBSD
# ---                 MIPS32/Linux
# ---                 MIPS32/Android
# ---                 MIPS64/Linux
# mips64le            ---
# ---                 PPC32/Linux
# ---                 PPC64/Linux
# ppc64le             PPC64LE/Linux
# riscv64             ---
# s390x               S390X/Linux
#
# On platforms where valgrind is unsupported (VALGRIND_PLATFORM="UNSUPPORTED"),
# we run tests without memory checks etc.
#
ARG VALGRIND_PLATFORM

USER root

ENV DEBIAN_ARCHITECTURE=$TARGETARCH
ENV VALGRIND_PLATFORM=$VALGRIND_PLATFORM
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC/UTC

#
# User mu
#
# Install a non-root user, to mitigate intrusions and mistakes
# at runtime.
#
# 32 digit random number for mu user's password.
#
RUN mkdir /home/mu \
    && useradd \
           --home-dir /home/mu \
           --password `od --read-bytes 32 --format u --address-radix none /dev/urandom | tr --delete ' \n'` \
           mu \
    && chown -R mu:mu /home/mu

#
# mu working directory
#
RUN mkdir -p /mu \
    && chown -R mu:mu /mu \
    && chmod ug+rwx,o-rwx /mu

#
# Packages for mu:
#
#     ca-certificates
#         Latest certificate authorities.
#     gcc
#         C compiler.
#     gdb
#         C debugger.
#     libpcre2-dev
#         UTF-8 character regular expressions.
#     libutf8lex
#         Lexing UTF-8 characters (https://github.com/jtienhaara/utf8lex).
#     libutf8proc-dev
#         UTF-8 character reading and categorizing.
#     libutf8proc2
#         UTF-8 character reading and categorizing.
#     locales [required] [dynamic]
#         Required both for building C code, and for runtime reading
#         and writing of UTF-8-encoded characters.
#     make
#         Traditional make.  Required for building things from Makefiles.
#     strace
#         For troubleshooting.
#     valgrind
#         For troubleshooting and finding memory leaks.
#     wget
#         For downloading libraries.
#
RUN apt-get update --yes \
    && apt-get install --no-install-recommends --yes \
       ca-certificates \
       gcc \
       gdb \
       libpcre2-dev \
       libutf8proc-dev \
       libutf8proc2 \
       locales \
       make \
       strace \
       wget \
    && if test "$VALGRIND_PLATFORM" != "UNSUPPORTED"; \
       then \
           apt-get install --no-install-recommends --yes \
               valgrind \
               ; \
       fi \
    && apt-get clean

ENV LC_CTYPE=C.utf8
ENV UTF8LEX_VERSION=0.0.1
ENV UTF8LEX_MAJOR=0

#
# Install utf8lex.
#
RUN wget https://github.com/jtienhaara/utf8lex/releases/download/v${UTF8LEX_VERSION}/libutf8lex.a.${UTF8LEX_VERSION}.$DEBIAN_ARCHITECTURE \
    --output-document /usr/lib/libutf8lex.a.${UTF8LEX_VERSION} \
    && wget https://github.com/jtienhaara/utf8lex/releases/download/v${UTF8LEX_VERSION}/libutf8lex.so.${UTF8LEX_VERSION}.$DEBIAN_ARCHITECTURE \
    --output-document /usr/lib/libutf8lex.so.${UTF8LEX_VERSION} \
    && wget https://github.com/jtienhaara/utf8lex/releases/download/v${UTF8LEX_VERSION}/utf8lex.h \
        --output-document /usr/include/utf8lex.h \
    && wget https://github.com/jtienhaara/utf8lex/releases/download/v${UTF8LEX_VERSION}/utf8lex.${UTF8LEX_VERSION}.$DEBIAN_ARCHITECTURE \
        --output-document /usr/bin/utf8lex \
    && chmod a+x \
           /usr/lib/libutf8lex.a.${UTF8LEX_VERSION} \
           /usr/lib/libutf8lex.so.${UTF8LEX_VERSION} \
           /usr/bin/utf8lex \
    && ln -s /usr/lib/libutf8lex.a.${UTF8LEX_VERSION} /usr/lib/libutf8lex.a.${UTF8LEX_MAJOR} \
    && ln -s /usr/lib/libutf8lex.a.${UTF8LEX_VERSION} /usr/lib/libutf8lex.a \
    && ln -s /usr/lib/libutf8lex.so.${UTF8LEX_VERSION} /usr/lib/libutf8lex.so.${UTF8LEX_MAJOR} \
    && ln -s /usr/lib/libutf8lex.so.${UTF8LEX_VERSION} /usr/lib/libutf8lex.so

USER mu
WORKDIR /mu

#
# No default entrypoint.
#
CMD [""]
ENTRYPOINT [""]
