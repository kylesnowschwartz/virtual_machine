require_relative './destinations.rb'
require_relative './sources.rb'

class Cpu
  attr_accesser :b

  def initialize
    @a = 0
    @b = 0
    @instruction_pointer = 0
    @instructions = [
      Instruction.new (:mov, SourceIn.new(self), DestinationA.new(self) ),
      Instruction.new (:jez, 4 ),
      Instruction.new (:add, SourceIn.new(self)),
      Instruction.new (:mov, SourceA.new(self), DestinationOut.new(self) ),
      Instruction.new (:jmp, -4 )
    ]
  end

  def run
    while true
      instruction = @instructions[@instruction_pointer]

      process_instruction(instruction)

      @instruction_pointer += 1
    end
  end

  def process_instruction(instruction)
    case instruction.op_code
    when :mov
      mov(instruction.arg1, instruction.arg2)
    when :swp
      swp
    when :sav
      sav
    when :add
      add(instruction.arg1)
    when :sub
      sub(instruction.arg1)
    when :jmp
      jmp(instruction.arg1)
    when :jez
      jez(instruction.arg1)
    when :jgz
      jgz(instruction.arg1)
    when :jnz
      jnz(instruction.arg1)
    when :jlz
      jlz(instruction.arg1)
    end
  end

  def write_bus_value(value)
    puts value
  end

  def read_bus_value
    gets.chomp.to_i 
  end

  private

  def mov(source, destination)
    destination.write_value(source.read_value) 
  end

  def swp
    @a, @b = @b, @a
  end

  def sav
    @b = @a
  end

  def add(source)
     @a += source.read_value
  end

  def sub(source)
    @a -= source.read_value
  end

  def jmp(instruction_count)
    #we don't want to increment instruction pointer when jumping
    @instruction_pointer += (instruction_count - 1)
  end

  def jez(instruction_count)
    if @a == 0
      jmp(instruction_count)
    end
  end


  def jnz(instruction_count)
    if @a != 0
      jmp(instruction_count)
    end
  end


  def jgz(instruction_count)
    if @a > 0
      jmp(instruction_count)
    end
  end

  def jlz(instruction_count)
    if @a < 0
      jmp(instruction_count)
    end
  end

end

class Instruction
  attr_reader :op_code, :arg1, :arg2

  def initialize(op_code, arg1, arg2 = nil)
    @op_code = op_code
    @arg1 = arg1
    @arg2 = arg2
  end
end










