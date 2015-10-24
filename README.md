# clj

[![][kla-logo]][kla-logo-large]

[kla-logo]: resources/images/clojure.png
[kla-logo-large]: resources/images/clojure.png

*Clojure functions and macros for LFE*

##### Contents

* [Introduction](#introduction-)
* [Dependencies](#dependencies-)
* [Installation](#installation-)
* [Usage](#usage-)


## Introduction [&#x219F;](#contents)

The clj library offers a collection of functions and macros that you may find useful
or enjoyable in LFE if you've come from a Clojure background.

This library is in the process of extracting the Clojure functionality that made its
way into the [lutil]() LFE library


## Dependencies [&#x219F;](#contents)

As of version 0.3.0, this project assumes that you have
[rebar3](https://github.com/rebar/rebar3) installed somwhere in your ``$PATH``.
It no longer uses the old version of rebar. If you do not wish to use rebar3,
you may use the most recent rebar2-compatible release of lutil: 0.2.1.


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
