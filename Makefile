fnl_files = $(wildcard fnl/*.fnl) colors.fnl
out_files = $(fnl_files:fnl/%.fnl=lua/%.lua) colors/onedarkfast.lua

all: $(out_files)

fmt: $(fnl_files)
	./fnlfmt --fix $<

lua/%.lua: fnl/%.fnl lua/
	fennel --raw-errors --globals-only vim,print --compile $< > $@

lua/:
	mkdir -p lua

colors/onedarkfast.lua: colors.fnl colors/
	fennel --raw-errors --compile $< > $@

colors/:
	mkdir -p colors

clean:
	rm -rf lua
	rm -rf colors

.PHONY: clean
