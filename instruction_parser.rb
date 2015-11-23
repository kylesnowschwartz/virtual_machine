require_relative './cpu.rb'

class InstructionParser
  def initialize(cpu_count)
    @cpu_count = cpu_count
  end

  def parse(lines)
    instructions = (0..@cpu_count).map { |cpu_id| [] }

    cpu_id = nil

    lines.each do |line|
      if line.start_with? '#'
        cpu_id = line[1..-1].to_i
      else
        instruction = parse_line(line)
        instructions[cpu_id] << instruction if instruction
      end
    end

    instructions
  end

  def parse_line(line)
    stripped_line = line.split('~')[0]

    return nil if stripped_line.chomp.empty?

    tokens = stripped_line.split(/,?\s/)

    op_code = tokens[0].to_sym

    args = tokens[1..-1]

    Instruction.new(op_code, args)
  end

end