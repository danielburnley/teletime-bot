class CommandParser
  def initialize(base="+teletime")
    @base = base
  end

  def parse(command)
    command = command.split(" ")

    if command.length == 1 && command[0] == @base
      return [:overview]
    end

    [:add, command[1], command[2]]
  end
end
