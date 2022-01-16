require_relative 'card'

class ClubCard < Card

  def initialize(idx)
    super(idx, :club)
  end
end
