require "timecop"
require_relative "../lib/teletime"

describe Teletime do
  before do
    Timecop.freeze(Date.today)
  end

  after do
    Timecop.return
  end

  let(:stored_teletime) do
    {
      a: {
        names: ["cat", "dog"], deadline: 123, status: "in progress"
      },
      b: {
        names: ["duck", "cow"], deadline: 123, status: "in progress"
      }
    }
  end

  let(:storage_stub) { spy(get: stored_teletime) }
  let(:subject) { described_class.new(storage_stub) }

  describe "overview" do
    let(:response) { subject.overview }

    before { response }

    it "gets the current stored teletime" do
      expect(storage_stub).to have_received(:get)
    end

    it "returns the current stored teletime" do
      expect(response).to eq(stored_teletime)
    end
  end

  describe "reset" do
    let(:response) { subject.reset }

    before { response }

    it "stores an empty teletime" do
      expect(storage_stub).to have_received(:store).with({
        a: {names: [], deadline: 0, status: "free"},
        b: {names: [], deadline: 0, status: "free"},
        c: {names: [], deadline: 0, status: "free"},
        d: {names: [], deadline: 0, status: "free"},
        e: {names: [], deadline: 0, status: "free"}
      })
    end
  end

  describe "set_status" do
    it "gets the current telephone" do
      subject.set_status("a", "done")
      expect(storage_stub).to have_received(:get)
    end

    it "stores an updated teletime: a, done" do
      subject.set_status("a", "done")
      expect(storage_stub).to have_received(:store).with({
        a: { names: ["cat", "dog"], deadline: 0, status: "done" },
        b: { names: ["duck", "cow"], deadline: 123, status: "in progress" }
      })
    end

    it "stores an updated teletime: b, free" do
      subject.set_status("b", "free")
      expect(storage_stub).to have_received(:store).with({
        a: { names: ["cat", "dog"], deadline: 123, status: "in progress" },
        b: { names: ["duck", "cow"], deadline: 0, status: "free" }
      })
    end
  end

  describe "set_hours" do
    let(:expected_time) {}
    it "gets the current telephone" do
      subject.add("a", "squirrel")
      expect(storage_stub).to have_received(:get)
    end

    it "stores an updated teletime: a, squirrel" do
      subject.set_hours("a", 10)
      expected_time = (Time.now + (10 * 60 * 60)).to_i

      expect(storage_stub).to have_received(:store).with({
        a: { names: ["cat", "dog"], deadline: expected_time, status: "in progress" },
        b: { names: ["duck", "cow"], deadline: 123, status: "in progress" }
      })
    end

    it "stores an updated teletime: b, bear" do
      subject.set_hours("b", 20)
      expected_time = (Time.now + (20 * 60 * 60)).to_i

      expect(storage_stub).to have_received(:store).with({
        a: { names: ["cat", "dog"], deadline: 123, status: "in progress" },
        b: { names: ["duck", "cow"], deadline: expected_time, status: "in progress" }
      })
    end
  end

  describe "add" do
    let(:expected_time) { (Time.now + (72 * 60 * 60)).to_i }
    it "gets the current telephone" do
      subject.add("a", "squirrel")
      expect(storage_stub).to have_received(:get)
    end

    it "stores an updated teletime: a, squirrel" do
      subject.add("a", "squirrel")
      expect(storage_stub).to have_received(:store).with({
        a: { names: ["cat", "dog", "squirrel"], deadline: expected_time, status: "in progress" },
        b: { names: ["duck", "cow"], deadline: 123, status: "in progress" }
      })
    end

    it "stores an updated teletime: b, bear" do
      subject.add("b", "bear")
      expect(storage_stub).to have_received(:store).with({
        a: { names: ["cat", "dog"], deadline: 123, status: "in progress" },
        b: { names: ["duck", "cow", "bear"], deadline: expected_time, status: "in progress" }
      })
    end
  end

  describe "clear_list" do
    it "gets the current telephone" do
      subject.clear_list("a")
      expect(storage_stub).to have_received(:get)
    end

    it "stores the cleared name list: a" do
      subject.clear_list("a")
      expect(storage_stub).to have_received(:store).with({
        a: { names: [], deadline: 0, status: "free" },
        b: { names: ["duck", "cow"], deadline: 123, status: "in progress" }
      })
    end

    it "stores the cleared name list: a" do
      subject.clear_list("b")
      expect(storage_stub).to have_received(:store).with({
        a: { names: ["cat", "dog"], deadline: 123, status: "in progress" },
        b: { names: [], deadline: 0, status: "free" }
      })
    end
  end

  describe "manual_list" do
    it "gets the current telephone" do
      subject.manual_list("a", "")
      expect(storage_stub).to have_received(:get)
    end

    it "stores the manual list: a" do
      subject.manual_list("a", "meow,quack")
      expect(storage_stub).to have_received(:store).with({
        a: { names: ["meow", "quack"], deadline: 123, status: "in progress" },
        b: { names: ["duck", "cow"], deadline: 123, status: "in progress" }
      })
    end

    it "stores the manual list: b" do
      subject.manual_list("b", "bark, moo")
      expect(storage_stub).to have_received(:store).with({
        a: { names: ["cat", "dog"], deadline: 123, status: "in progress" },
        b: { names: ["bark", "moo"], deadline: 123, status: "in progress" }
      })
    end
  end
end