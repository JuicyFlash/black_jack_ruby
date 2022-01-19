
require_relative 'player'

class ComputerPlayer < Player
  def initialize(name, bank, deck)
    super
    controlled_by = :computer
  end

  def need_card?
    super && score <= 17
  end

end
