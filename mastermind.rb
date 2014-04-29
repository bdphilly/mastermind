class Code

  COLORS = ['R', 'G', 'B', 'Y', 'O', 'P']

  attr_accessor :sequence

  def initialize
    @sequence = []
  end

  #generates a random sequence
  def make_sequence
    4.times do
      self.sequence << COLORS.sample
    end
  end

  def parse(user_input)
    # p user_input
    parsed_input = user_input.upcase.split('')
    if parsed_input.length == 4 &&
          parsed_input.all? { |char| COLORS.include?(char)}
        # p 'YOU ARE HERE'
        # p parsed_input
      return parsed_input
    else
      p "ERROR"
      nil
    end
  end
end


class Game

  attr_accessor :board, :turns

  def initialize
    @turns = 0
    @board = Code.new
    @board.make_sequence
  end

  def win?(pin_array)
    pin_array == [4,0]
  end

  def get_white(parsed_guess, dup_seq)
    white_pins = 0
    parsed_guess.each_with_index do |guess, index|
      if dup_seq.include?(guess)
        # dup_seq[index] = ' '
        dup_seq[dup_seq.index(guess)] = ' '
        parsed_guess[index] = ' '
        white_pins += 1
      end
    end
    white_pins
  end

  def get_black(parsed_guess)
    black_pins = 0

    dup_seq = self.board.sequence.dup
    indices_to_remove = []
    4.times do |pos|
      #black pin
      if dup_seq[pos] == parsed_guess[pos]
        indices_to_remove << pos
        black_pins += 1
      end
    end

    indices_to_remove.each do |index|
      dup_seq[index] = ' '
      parsed_guess[index] = '.'
    end
    [parsed_guess, dup_seq, black_pins]
  end

  def get_matches(parsed_guess)
    #first is black, white is second
    parsed_guess, dup_seq, black_pins = self.get_black(parsed_guess)

    white_pins = self.get_white(parsed_guess, dup_seq)

    [black_pins, white_pins]
  end

  def run
    p @board
    pin_array = [0,0]
    8.times do |turn|
      if win?(pin_array)
        puts "you are winner"
        return
      end
      parsed_guess = get_user_guess
      pin_array = get_matches(parsed_guess)
      p pin_array
    end

    puts 'loser!'
  end

  #TESTED
  def get_user_guess
    puts "Please make a guess:"
    loop do
      user_guess = gets.chomp
      parsed_guess = self.board.parse(user_guess)
      break unless parsed_guess.nil?
      puts "Invalid guess. Please guess again."
    end
    parsed_guess
  end

end

game = Game.new
# game.run
game.run
