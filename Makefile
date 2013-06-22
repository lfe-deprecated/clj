DEPS = ./deps
LFE_DIR = $(DEPS)/lfe
LFE_EBIN = $(LFE_DIR)/ebin
LFE = $(LFE_DIR)/bin/lfe
LFEC = $(LFE_DIR)/bin/lfec
LFEUNIT_DIR = $(DEPS)/lfeunit
ERL_LIBS = $(LFE_DIR):$(EREDIS_DIR):$(LFEUNIT_DIR):./
SOURCE_DIR = ./src
OUT_DIR = ./ebin
TEST_DIR = ./test
TEST_OUT_DIR = ./.eunit

get-deps:
	rebar get-deps
	for DIR in $(wildcard $(DEPS)/*); do 	cd $$DIR; git pull; cd - ; done

clean-ebin:
	rm -f $(OUT_DIR)/*.beam

clean-eunit:
	rm -rf $(TEST_OUT_DIR)

compile: get-deps clean-ebin
	rebar compile

compile-tests: clean-eunit
	mkdir -p $(TEST_OUT_DIR)
	ERL_LIBS=$(ERL_LIBS) $(LFEC) -o $(TEST_OUT_DIR) $(TEST_DIR)/*_tests.lfe

shell: compile
	clear
	ERL_LIBS=$(ERL_LIBS) $(LFE) -pa $(TEST_OUT_DIR)

clean: clean-ebin clean-eunit
	rebar clean

check: compile compile-tests
	@clear;
	@rebar eunit verbose=1 skip_deps=true
