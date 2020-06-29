
ARCH ?= im

src_dir   := $(CURDIR)
obj_dir   := $(bld_dir)/sqrt
obj       := $(obj_dir)/sqrt.o
test_elf  := $(bld_dir)/sqrt.elf
test_hex  := $(bld_dir)/sqrt.hex
test_dump := $(bld_dir)/sqrt.dump

CFLAGS := -I$(inc_dir) -I$(src_dir) -DASM -Wa,-march=rv32$(ARCH) -march=rv32$(ARCH) -mabi=ilp32 -D__riscv_xlen=32 
LDFLAGS := -static -fvisibility=hidden -nostdlib -nostartfiles -T$(inc_dir)/link.ld -march=rv32$(ARCH) -mabi=ilp32

default: $(test_elf) $(test_hex) $(test_dump)

$(obj_dir)/sqrt.o : $(src_dir)/sqrt.S | $(obj_dir)
	$(RISCV_GCC) -c $< $(CFLAGS) -o $@

$(obj_dir) :
	mkdir -p $(obj_dir)

$(bld_dir)/sqrt.elf: $(obj_dir)/sqrt.o | $(obj_dir)
	$(RISCV_GCC) $^ $(LDFLAGS) -o $@

$(bld_dir)/%.hex: $(bld_dir)/%.elf
	$(RISCV_OBJCOPY) $^ $@

$(bld_dir)/%.dump: $(bld_dir)/%.elf
	$(RISCV_OBJDUMP) $^ > $@

clean:
	$(RM) $(test_elf) $(test_hex) $(test_dump) $(obj)
	$(RM) -R $(obj_dir)