set disassembly-flavor intel
 
set pagination off 
 
set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on

catch exec
set disable-randomization on

source $HOME/.gdbinit-gef.py