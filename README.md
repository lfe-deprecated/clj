# clj

**DEPRECATED**: This library is no longer maintained! Nor is it useful, since the functionality it provides has been moved into LFE-proper (see the `clj` module).

[![][kla-logo]][kla-logo-large]

[kla-logo]: priv/images/clojure.png
[kla-logo-large]: priv/images/clojure.png

*Clojure functions and macros for LFE*

##### Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [Installation](#installation-)
* [Usage](#usage-)
* [Future](#future-)


## Introduction [&#x219F;](#contents)

The clj library offers a collection of functions and macros that you may find useful
or enjoyable in LFE if you've come from a Clojure background.

This library is in the process of extracting the Clojure functionality that made its
way into the [lutil](https://github.com/lfex/lutil#contents) LFE library


## Dependencies [&#x219F;](#contents)

As of version 0.3.0, this project assumes that you have
[rebar3](https://github.com/rebar/rebar3) installed somwhere in your ``$PATH``.
It no longer uses the old version of rebar. If you do not wish to use rebar3,
you may use the most recent rebar2-compatible release of clj: 0.2.1.


## Installation [&#x219F;](#contents)

In your ``rebar.config`` file, update your ``deps`` section to include
``clj``:

```erlang
  {deps, [
    ...
    {clj, ".*",
      {git, "git@github.com:lfex/clj.git", {tag, "0.3.0"}}}
      ]}.
```


## Usage [&#x219F;](#contents)

TBD

(We are changing the functions and macros from what they were in lutil, so usage has
not yet stabilized. If you want to be an alpha tester/user, be sure to look at the
unit tests and code comments, both in the modules and in the include files.)

## Future [&#x219F;](#contents)

The future of the clj library is quite bright :-) In a couple posts on the LFE mail list, Robert Virding has offered to bring Clojure functionality into LFE-proper:
 * https://groups.google.com/d/msg/lisp-flavoured-erlang/668_n6F6qHU/FE61waXoDAAJ
 * https://groups.google.com/d/msg/lisp-flavoured-erlang/j_PO4Ol5Rkw/OotEtbjoEQAJ

The rest is up to us :-) As such, I will be creating a series of tickets in this repo targeted against a branch of Robert's LFE repo. Anyone in the community may make a contribution to this branch -- simply sumbit a PR. Once we have critical mass on Clojure-inspired functions and macros, I will submit a PR to upstream LFE, and all of our work will be included :-)

Here's the branch:
 * https://github.com/oubiwann/lfe/tree/add-clojure-lib

Here are the tickets you can chose from to implement your favourite Clojure bits in LFE (if you don't see the one you want, add it!):
 * https://github.com/lfex/clj/labels/Clojure%20Lib%20for%20LFE

**IMPORTANT**: Even though these tickets are in the lfex/clj repo, you will be working against a branch of oubiwann/lfe! Do not submit PRs against lfex/clj -- submit them against the add-clojure-lib branch of oubiwann/lfe.

Now go forth, and help these two worlds to collide :-D
