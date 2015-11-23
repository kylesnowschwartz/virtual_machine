require_relative './cpu.rb'
require 'fiber'

class VirtualMachine
  CPU_COUNT = 10

  Struct.new("PortAddress", :from_cpu_id, :to_cpu_id)

  def initialize(file)
    @file = file
    @bus_messages = {}
  end

  def run
    lines = IO.readlines(@file)

    cpu_id = nil
    instructions = (0..CPU_COUNT).map { |cpu_id| [] }

    lines.each do |line|
      if line.start_with? '#'
        cpu_id = line[1..-1].to_i
      else
        instruction = parse_line(line)
        instructions[cpu_id] << instruction if instruction
      end
    end

    # bus = Bus.new

    cpus =  instructions.map { |instruction| Cpu.new(self, instruction) }

    @fibers = cpus.map do |cpu|
      Fiber.new { cpu.run }
    end

    @bus_fiber = Fiber.new { start_bus }

    @bus_fiber.resume
  end

  def start_bus
    cpu_id = 0

    while cpu_id
      # puts "resuming cpu: #{cpu_id}"
      cpu_id = @fibers[cpu_id].resume
    end
  end

# end

# class Bus
  def read_value
    $stdin.gets.chomp.to_i
  end

  def write_value(value)
    puts value
  end

  def write_cpu_value(cpu_id, value)
    from_cpu_id = @fibers.index(Fiber.current)

    port_address = Struct::PortAddress.new(from_cpu_id, cpu_id)
    
    @bus_messages[port_address] = value
    
    Fiber.yield cpu_id
  end

  def read_cpu_value(cpu_id)
    to_cpu_id = @fibers.index(Fiber.current)

    port_address = Struct::PortAddress.new(cpu_id, to_cpu_id)

    value = @bus_messages[port_address]

    return value if value

    Fiber.yield cpu_id
  end

  def parse_line(line)
    return nil if line.chomp.empty?

    tokens = line.split('~')[0].split(/,?\s/)

    op_code = tokens[0].to_sym

    args = tokens[1..-1]

    Instruction.new(op_code, args)
  end
end

vm = VirtualMachine.new(ARGV[0])
vm.run