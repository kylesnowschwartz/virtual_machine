require_relative './destinations.rb'
require_relative './sources.rb'

class Cpu
  attr_accessor :a

  def initialize(bus, instructions)
    @bus = bus
    @a = 0
    @b = 0
    @instruction_pointer = 0
    @instructions = instructions
  end

  def run
    while @instruction_pointer < @instructions.size
      instruction = @instructions[@instruction_pointer]
      # p "pointer: #{@instruction_pointer}"
      # p "a: #{@a}, b: #{@b}"
      # p "instruction: #{instruction.inspect}"
      process_instruction(instruction)

      @instruction_pointer = [@instruction_pointer + 1, 0].max
      # p "after pointer: #{@instruction_pointer}"
    end
  end

  def get_source(source_str)
    case source_str
    when 'in'
      SourceIn.new(@bus)
    when 'a'
      SourceA.new(self)
    when 'null'
      SourceNull.new
    else
      if source_str.start_with?('#')
        SourceCpu.new(@bus, source_str[1..-1].to_i)
      else
        SourceInt.new(source_str.to_i)
      end
    end
  end

  def get_dest(dest_str)
    case dest_str
    when 'out'
      DestinationOut.new(@bus)
    when 'a'
      DestinationA.new(self)
    when 'null'
      DestinationNull.new
    else
      DestinationCpu.new(@bus, dest_str[1..-1].to_i)
    end
  end

  def process_instruction(instruction)
    case instruction.op_code
    when :mov
      mov(get_source(instruction.args[0]), get_dest(instruction.args[1]))
    when :swp
      swp
    when :sav
      sav
    when :add
      add(get_source(instruction.args[0]))
    when :sub
      sub(get_source(instruction.args[0]))
    when :mul
      mul(get_source(instruction.args[0]))
    when :div
      div(get_source(instruction.args[0]))
    when :jmp
      jmp(instruction.args[0].to_i)
    when :jez
      jez(instruction.args[0].to_i)
    when :jgz
      jgz(instruction.args[0].to_i)
    when :jnz
      jnz(instruction.args[0].to_i)
    when :jlz
      jlz(instruction.args[0].to_i)
    end
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

  def mul(source)
    @a *= source.read_value
  end

  def div(source)
    value = source.read_value
    @b = @a % value
    @a /= value
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
  attr_reader :op_code, :args

  def initialize(op_code, args)
    @op_code = op_code
    @args = args
  end
end