# Disable the stupid <RET>/q/c prompt:
set pagination off

# Sorry :-(
set disassembly-flavor intel

set history save on
set history filename ~/.gdb-history
set history size 1000

set confirm off

set print pretty on

define bta
    thread apply all backtrace
end

define xxd
    dump binary memory /tmp/dump.bin $arg0 ((char *)$arg0)+$arg1
    shell xxd -g 1 /tmp/dump.bin
end
