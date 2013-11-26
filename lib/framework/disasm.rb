#!/usr/bin/env ruby

module JSDetox
module Disassembler

include Metasm

def self.disassemble(data, opts = {})
  metasm_opts = {
    :cpu => 'Ia32',
    :dump_data => true,
  }
  metasm_opts[:cpu] = 'X64' if opts[:sc_arch] == '64'

  exefmt = AutoExe.orshellcode { Metasm.const_get(metasm_opts[:cpu]).new }
  exe = exefmt.load(data)
  dasm = exe.init_disassembler

  begin
    exe.disassemble
  rescue Interrupt
    return nil
  end

  res = ""
  dasm.dump(metasm_opts[:dump_data]) { |e| res+= e + $/ }
  res.strip!
  res
end

end
end
