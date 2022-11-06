# Disable the stupid <RET>/q/c prompt:
set pagination off
# When I type something, I mean it:
set confirm off
# Pretty-print structures:
set print pretty on

define bta
    thread apply all backtrace
end

# The Intel flavor was my first.
set disassembly-flavor intel

set history save on
set history filename ~/.gdb-history
set history size 10000

set debuginfod enabled on

define xxd
    dump binary memory /tmp/dump.bin $arg0 ((char *)$arg0)+$arg1
    shell xxd -groupsize 1 /tmp/dump.bin
    shell rm -f /tmp/dump.bin
end
