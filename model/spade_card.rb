require_relative 'card'

class SpadeCard < Card

  def initialize(idx)
    super(idx, :spade)
  end
end
