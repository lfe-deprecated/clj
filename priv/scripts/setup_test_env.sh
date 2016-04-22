#!/usr/bin/env bash

REBAR=(readlink -f `PATH=.:$PATH which rebar3`)
LFE_TEST_BUILD=`pwd`/_build/test
cd ${LFE_TEST_BUILD}/lib/lutil && \
mkdir -p _build && \
(test -e _build/default || \
ln -s ${LFE_TEST_BUILD} _build/default)
cd ${LFE_TEST_BUILD}/lib/lutil && \
$REBAR compile || echo "Already compiled."
