class SourceIn
  def initialize(cpu)
    @cpu = cpu
  end

  def read_value
    @cpu.read_bus_value
  end
end

class SourceA
  def initialize(cpu)
    @cpu = cpu
  end

  def read_value
    @cpu.a
  end
end

class SourceNull
  def read_value
    0
  end
end

class SourceInt
  def initialize(value)
    @value = value
  end

  def read_value
    @value
  end
end