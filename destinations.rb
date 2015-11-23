class DestinationOut
  def initialize(bus)
    @bus = bus
  end

  def write_value(value)
    @bus.write_value(value)
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

class DestinationCpu
  def initialize(bus, cpu_id)
    @cpu_id = cpu_id
    @bus = bus
  end

  def write_value(value)
    @bus.write_cpu_value(@cpu_id, value)
  end
end

