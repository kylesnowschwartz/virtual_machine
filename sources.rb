class SourceIn
  def initialize(bus)
    @bus = bus
  end

  def read_value
    @bus.read_value
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

class SourceCpu
  def initialize(bus, cpu_id)
    @cpu_id = cpu_id
    @bus = bus
  end

  def read_value
    @bus.read_cpu_value(@cpu_id)
  end
end