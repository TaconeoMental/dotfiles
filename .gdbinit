source ~/.gdb/pwndbg/gdbinit.py
set context-clear-screen on

source ~/.gdb/splitmind/gdbinit.py

python
import splitmind
(splitmind.Mind()
 .right(display="regs")
 .below(display="stack")
 .above(of="main", display="disasm")
  #.below(display="backtrace", size="50%")
 .show("legend", on="disasm")
).build()
end

set context-code-lines 20
set context-source-code-lines 20
