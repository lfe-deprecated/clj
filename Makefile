DEPS = ./deps
BIN_DIR=./bin
EXPM=$(BIN_DIR)/expm
PROJECT=lfe-utils
LIB=$(PROJECT)
LFE_DIR = $(DEPS)/lfe
LFE_EBIN = $(LFE_DIR)/ebin
LFE = $(LFE_DIR)/bin/lfe
LFEC = $(LFE_DIR)/bin/lfec
LFEUNIT_DIR = $(DEPS)/lfeunit
SOURCE_DIR = ./src
OUT_DIR = ./ebin
TEST_DIR = ./test
TEST_OUT_DIR = ./.eunit
FINISH=-run init stop -noshell
ERL_LIBS = $(shell find $(DEPS) -depth 1 -exec echo -n '{}:' \;|sed 's/:$$/:./'):$(TEST_OUT_DIR)

get-erllibs:
	@echo $(ERL_LIBS)

get-version:
	@echo
	@echo -n app.src: ''
	@erl -eval 'io:format("~p~n", [ \
		proplists:get_value(vsn,element(3,element(2,hd(element(3, \
		erl_eval:exprs(element(2, erl_parse:parse_exprs(element(2, \
		erl_scan:string("Data = " ++ binary_to_list(element(2, \
		file:read_file("src/$(LIB).app.src"))))))), []))))))])' \
		$(FINISH)
	@echo -n package.exs: ''
	@grep version package.exs |awk '{print $$2}'|sed -e 's/,//g'
	@echo -n git tags: ''
	@echo `git tag`

# Note that this make target expects to be used like so:
#	$ ERL_LIB=some/path make get-install-dir
#
# Which would give the following result:
#	some/path/lfe-rackspace-1.0.0
#
get-install-dir:
	@echo $(ERL_LIB)/$(PROJECT)-$(shell make get-version)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(EXPM): $(BIN_DIR)
	@echo "Downloading EXPM ..."
	@curl -o $(EXPM) http://expm.co/__download__/expm
	@chmod +x $(EXPM)

get-deps:
	@echo "Getting dependencies ..."
	@rebar get-deps
	@for DIR in $(wildcard $(DEPS)/*); do \
	cd $$DIR; git pull; cd - ; done

clean-ebin:
	@echo "Cleaning ebin dir ..."
	@-rm -f $(OUT_DIR)/*.beam

clean-eunit:
	@echo "Cleaning eunit dir ..."
	rm -rf $(TEST_OUT_DIR)

compile: get-deps clean-ebin
	@echo "Compiling dependencies and project code ..."
	ERL_LIBS=$(ERL_LIBS) rebar compile

compile-only: clean-ebin
	@echo "Compiling project code ..."
	@ERL_LIBS=$(ERL_LIBS) rebar compile skip_deps=true

compile-tests: clean-eunit
	@echo "Compiling unit test code ..."
	man find
	mkdir -p $(TEST_OUT_DIR)
	ERL_LIBS=$(ERL_LIBS) $(LFEC) -o $(TEST_OUT_DIR) $(TEST_DIR)/*tests.lfe

shell: compile
	@clear
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -pa $(TEST_OUT_DIR)

shell-only: compile-only
	@clear
	@ERL_LIBS=$(ERL_LIBS) $(LFE) -pa $(TEST_OUT_DIR)

clean: clean-ebin clean-eunit
	@#rebar clean

check: compile compile-tests
	@echo "Running unit tests ..."
	@clear
	@ERL_LIBS=$(ERL_LIBS) rebar eunit verbose=1 skip_deps=true

check-only: compile-only compile-tests
	@echo "Running unit tests ..."
	@clear;
	@ERL_LIBS=$(ERL_LIBS) rebar eunit verbose=1 skip_deps=true

check-travis: compile compile-tests
	@echo "Running unit tests ..."
	ERL_LIBS=$(ERL_LIBS) erl -pa .eunit -noshell \
	-eval "eunit:test({inparallel,[\
		`ls .eunit| \
		sed -e 's/.beam//'| \
		awk '{print "\x27" $$1 "\x27"}'| \
		sed ':a;N;$$!ba;s/\n/,/g'`]},[verbose])" \
	-s init stop

# Note that this make target expects to be used like so:
#	$ ERL_LIB=some/path make install
#
install: INSTALLDIR=$(shell make get-install-dir)
install: compile
	if [ "$$ERL_LIB" != "" ]; \
	then mkdir -p $(INSTALLDIR)/$(EBIN); \
		mkdir -p $(INSTALLDIR)/$(SRC); \
		cp -pPR $(EBIN) $(INSTALLDIR); \
		cp -pPR $(SRC) $(INSTALLDIR); \
	else \
		echo "ERROR: No 'ERL_LIB' value is set in the env." \
		&& exit 1; \
	fi

push-all:
	git push --all
	git push upstream --all
	git push --tags
	git push upstream --tags

upload: $(EXPM) get-version
	@echo "Package file:"
	@echo
	@cat package.exs
	@echo
	@echo "Continue with upload? "
	@read
	$(EXPM) publish
