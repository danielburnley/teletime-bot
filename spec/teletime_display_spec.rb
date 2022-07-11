require_relative "../lib/teletime_display"

describe TeletimeDisplay do
  let(:subject) { described_class.new }
  let(:teletime) do
    {
      a: {
        names: ["cat", "dog"], deadline: 123, status: "in progress"
      },
      b: {
        names: ["duck", "cow"], deadline: 456, status: "in progress"
      }
    }
  end

  before { Timecop.freeze(Date.today) }
  after { Timecop.return }

  context "#format_teletime" do
    it "Formats the teletime for the A branch" do
      res = subject.format_teletime(teletime)
      expect(res).to include("**A(dog):**")
      expect(res).to include("A: cat, dog (2)")
      expect(res).to include("<t:123:R>")
      expect(res).to include("<t:123:F>")
    end

    it "Formats the teletime for the B branch" do
      res = subject.format_teletime(teletime)
      expect(res).to include("**B(cow):**")
      expect(res).to include("B: duck, cow (2)")
      expect(res).to include("<t:456:R>")
      expect(res).to include("<t:456:F>")
    end
  end
end
