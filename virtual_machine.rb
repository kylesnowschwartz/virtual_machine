require_relative './cpu.rb'

class VirtualMachine
  def initialize(file)
    @file = file
  end

  def run
    lines = IO.readlines(@file)

    instructions = lines.map { |line| parse_line(line) }.select { |instruction| instruction }

    @cpu = Cpu.new(instructions)

    @cpu.run
  end

  def parse_line(line)
    return nil if line.start_with?('#') || line.chomp.empty?

    tokens = line.split('~')[0].split(/,?\s/)

    op_code = tokens[0].to_sym

    args = tokens[1..-1]

    Instruction.new(op_code, args)
  end
end

vm = VirtualMachine.new(ARGV[0])
vm.run