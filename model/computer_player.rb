
require_relative 'player'

class ComputerPlayer < Player
  def initialize(name, bank)
    super
  end

  def need_card?
    super && score <= 17
  end

end
