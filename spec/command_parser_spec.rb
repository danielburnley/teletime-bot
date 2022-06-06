require_relative "../lib/command_parser"

describe CommandParser do
  let(:subject) { described_class.new }

  context "Empty command" do
    it "returns overview" do
      command = subject.parse("+teletime")
      expect(command).to eq([:overview])
    end

    it "returns overview with trailing whitespace" do
      command = subject.parse("+teletime  ")
      expect(command).to eq([:overview])
    end
  end

  context "Adding to a branch" do
    it "returns the parsed command: example one" do
      command = subject.parse("+teletime a cat")
      expect(command).to eq([:add, "a", "cat"])
    end

    it "returns the parsed command: example two" do
      command = subject.parse("+teletime d dog")
      expect(command).to eq([:add, "d", "dog"])
    end

    it "parses commands with additional whitespace" do
      command = subject.parse("+teletime    d   dog")
      expect(command).to eq([:add, "d", "dog"])
    end
  end
end

