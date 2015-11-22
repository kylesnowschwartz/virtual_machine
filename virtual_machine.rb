require_relative './cpu.rb'

class VirtualMachine
  CPU_COUNT = 10

  def initialize(file)
    @file = file
  end

  def run
    lines = IO.readlines(@file)

    cpu_id = nil
    instructions = [0..CPU_COUNT].map { |cpu_id| [] }

    lines.each do |line|
      if line.start_with? '#'
        cpu_id = line[1..-1].to_i
      else
        instruction = parse_line(line)
        instructions[cpu_id] << instruction if instruction
      end
    end

    bus = Bus.new

    cpus =  instructions.map { |instruction| Cpu.new(bus, instruction) }

    cpus.each do |cpu|
      cpu.run
    end
  end

  def parse_line(line)
    return nil if line.chomp.empty?

    tokens = line.split('~')[0].split(/,?\s/)

    op_code = tokens[0].to_sym

    args = tokens[1..-1]

    Instruction.new(op_code, args)
  end
end

class Bus
  def read_value
    $stdin.gets.chomp.to_i
  end

  def write_value(value)
    puts value
  end

  def write_cpu_value(cpu_id, value)
  end

  def read_cpu_value(cpu_id)
  end
end

vm = VirtualMachine.new(ARGV[0])
vm.run