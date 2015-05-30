ifeq ($(shell which erl),)
$(error Can't find Erlang executable 'erl')
exit 1
endif
OS := $(shell uname -s)
ifeq ($(OS),Linux)
HOST=$(HOSTNAME)
endif
ifeq ($(OS),Darwin)
HOST = $(shell scutil --get ComputerName)
endif

LIB = $(PROJECT)
DEPS = ./deps
BIN_DIR = $(shell pwd)/bin
SOURCE_DIR = ./src
OUT_DIR = ./ebin
TEST_DIR = ./test
TEST_OUT_DIR = ./.eunit
SCRIPT_PATH = $(shell pwd):$(DEPS)/lfe/bin:$(BIN_DIR):$(PATH):/usr/local/bin

ifeq ($(shell which lfetool),)
LFETOOL=$(BIN_DIR)/lfetool
else
LFETOOL=lfetool
endif
ERL_LIBS = $(shell pwd):$(shell $(LFETOOL) info erllibs)
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

get-lfetool: $(BIN_DIR)
	curl -L -o ./lfetool https://raw.githubusercontent.com/lfe/lfetool/dev-v1/lfetool && \
	chmod 755 ./lfetool && \
	mv ./lfetool $(BIN_DIR)
	$(LFETOOL) -x

copy-appsrc:
	@mkdir -p $(OUT_DIR)
	@cp src/lutil.app.src ebin/lutil.app

get-version:
	@PATH=$(SCRIPT_PATH) $(LFETOOL) info version
	@echo "Erlang/OTP, LFE, & library versions:"
	@ERL_LIBS=$(ERL_LIBS) PATH=$(SCRIPT_PATH) erl \
	-eval "lfe_io:format(\"~p~n\",[lutil:'get-versions'()])." \
	-noshell -s erlang halt

get-erllibs:
	@echo "ERL_LIBS from lfetool:"
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) info erllibs

get-codepath:
	@echo "Code path:"
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) \
	erl -eval "io:format(\"~p~n\", [code:get_path()])." -noshell -s erlang halt

debug: get-erllibs get-codepath

get-deps:
	@echo "Getting dependencies ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) \
	$(LFETOOL) download deps || \
	(which rebar.cmd >/dev/null 2>&1 && rebar.cmd get-deps || rebar get-deps)

clean-ebin:
	@echo "Cleaning ebin dir ..."
	@rm -f $(OUT_DIR)/*.beam

clean-eunit:
	-@PATH=$(SCRIPT_PATH) $(LFETOOL) tests clean

deps/ltest:
	git clone https://github.com/lfex/ltest.git deps/ltest
	cd deps/ltest && \
	ln -s ../../bin . && \
	ln -a ../../deps . && \
	make compile

compile-tests: clean-eunit deps/ltest
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests build

repl: compile
	@which clear >/dev/null 2>&1 && clear || printf "\033c"
	@echo "Starting an LFE REPL ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) repl

repl-no-deps: compile-no-deps
	@which clear >/dev/null 2>&1 && clear || printf "\033c"
	@echo "Starting an LFE REPL ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) repl

shell: compile
	@which clear >/dev/null 2>&1 && clear || printf "\033c"
	@echo "Starting an Erlang shell ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) erl

shell-no-deps: compile-no-deps
	@which clear >/dev/null 2>&1 && clear || printf "\033c"
	@echo "Starting an Erlang shell ..."
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) erl

compile: get-deps clean-ebin copy-appsrc
	@echo "Compiling project code and dependencies ..."
	@which rebar.cmd >/dev/null 2>&1 && \
	PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) rebar.cmd compile || \
	PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) rebar compile

compile-no-deps: clean-ebin
	@echo "Compiling only project code ..."
	@which rebar.cmd >/dev/null 2>&1 && \
	PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) \
	rebar.cmd compile skip_deps=true || \
	PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) rebar compile skip_deps=true

clean: clean-ebin clean-eunit
	@which rebar.cmd >/dev/null 2>&1 && rebar.cmd clean || rebar clean

check-unit-only: clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests unit

check-integration-only: clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests integration

check-system-only: clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests system

check-unit-with-deps: get-deps compile compile-tests check-unit-only
check-unit: compile-no-deps check-unit-only
check-integration: compile check-integration-only
check-system: compile check-system-only
check-all-with-deps: compile check-unit-only check-integration-only \
	check-system-only
check-all: get-deps compile-no-deps clean-eunit
	@PATH=$(SCRIPT_PATH) ERL_LIBS=$(ERL_LIBS) $(LFETOOL) tests all

check: check-unit-with-deps

prep-travis:
	mkdir -p ~/.lfe/libs

check-travis: prep-travis compile compile-tests check-unit-only

push-all:
	@echo "Pusing code to github ..."
	git push --all
	git push upstream --all
	git push --tags
	git push upstream --tags

install: compile
	@echo "Installing lutil ..."
	@PATH=$(SCRIPT_PATH) $(LFETOOL) install lfe
