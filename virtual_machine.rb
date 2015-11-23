require_relative './cpu.rb'
require_relative './instruction_parser.rb'
require 'fiber'

class VirtualMachine
  CPU_COUNT = 10

  Struct.new("PortAddress", :from_cpu_id, :to_cpu_id)

  def initialize(file)
    @file = file
    @bus_messages = {}
  end

  def setup
    lines = IO.readlines(@file)

    instructions = InstructionParser.new(CPU_COUNT).parse(lines)

    cpus =  instructions.map { |instruction| Cpu.new(self, instruction) }

    @fibers = cpus.map do |cpu|
      Fiber.new { cpu.run }
    end
  end

  def run
    setup

    cpu_id = 0

    while cpu_id
      # puts "resuming cpu: #{cpu_id}"
      cpu_id = @fibers[cpu_id].resume

      if cpu_id.nil?
        fiber = @fibers.select { |f| f.alive? }.first
        cpu_id = @fibers.index(fiber)
      end
    end
  end

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
    
    # this loop allows a fiber to be resumed multiple times
    until @bus_messages[port_address].nil?
      Fiber.yield cpu_id
    end
  end

  def read_cpu_value(cpu_id)
    to_cpu_id = @fibers.index(Fiber.current)

    port_address = Struct::PortAddress.new(cpu_id, to_cpu_id)

    while true
      value = @bus_messages.delete(port_address)

      return value if value

      Fiber.yield cpu_id
    end
  end
end

vm = VirtualMachine.new(ARGV[0])
vm.run