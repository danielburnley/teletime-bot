class BranchInvalidError < StandardError
  def initialize(msg="Please enter a valid branch")
    super
  end
end
