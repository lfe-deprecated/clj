PROJECT = clj
LFE = _build/default/lib/lfe/bin/lfe

compile:
	rebar3 compile

check:
	@rebar3 as test eunit

repl: compile
	@$(LFE)

shell:
	@rebar3 shell

clean:
	@rebar3 clean
	@rm -rf ebin/* _build/default/lib/$(PROJECT)

clean-all: clean
	@rebar3 as dev lfe clean
