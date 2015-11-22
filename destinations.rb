class DestinationOut
  def initialize(cpu)
    @cpu = cpu
  end

  def write_value(value)
    @cpu.write_bus_value(value)
  end
end

class DestinationA
  def initialize(cpu)
    @cpu = cpu
  end

  def write_value(value)
    @cpu.a = value
  end
end

class DestinationNull
  def write_value(value)
  end
end

