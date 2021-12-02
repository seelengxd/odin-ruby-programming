module Colors
  COLORS =  %w[red yellow green blue black white]
  NUM_COLORS = 6
end

class HumanPlayer
  include Colors

  def get_color
    choice = nil;
    until COLORS.include?(choice) do
      puts "Pick a color from #{COLORS}"
      choice = gets.chomp.downcase
      puts 'Invalid choice!' unless COLORS.include?(choice)
    end
    choice
  end

  def get_code
    puts 'Pick colors!'
    (1..4).map do |i|
      puts "Color #{i}"
      get_color
    end
  end
end

class Computer
  include Colors
  def get_code
    colors = []
    color = nil
    4.times do
      color = COLORS[rand(NUM_COLORS)] while !color || colors.include?(color)
      colors << color
    end
    # p colors
    colors
  end
end

class Mastermind
  include Colors

  def initialize
    @lives = 12
    players
    round
  end

  def who_guess
    valid = %w[y n]
    puts 'Do you want to guess(y) or give the code(n)?'
    choice = nil
    until choice && valid.include?(choice)
      choice = gets.chomp.downcase
      puts 'Invalid choice' unless valid.include?(choice)
    end
    choice == 'y' ? 'player' : 'computer'
  end

  def players
    guesser = who_guess
    if guesser == 'player'
      @guesser = HumanPlayer.new
      code_giver = Computer.new
    else
      @guesser = Computer.new
      code_giver = HumanPlayer.new
    end
    get_code(code_giver)
  end

  def get_code(code_giver)
    @code = code_giver.get_code
    until @code.uniq.length == 4
      puts 'Code must be unique!'
      @code = code_giver.get_code
    end
  end

  def check_guess(guess)
    correct_spot = 0
    color_correct = 0
    guess.each_with_index do |color, index|
      if color == @code[index]
        correct_spot += 1
      elsif @code.include?(color)
        color_correct += 1
      end
    end
    [correct_spot, color_correct]
  end

  def turn
    puts "Lives left: #{@lives}"
    guess = @guesser.get_code
    correct_spot, color_correct = check_guess(guess)
    if correct_spot == 4
      puts 'wow you won!'
      true
    else
      puts "colors in correct spot: #{correct_spot}"
      puts "correct colors in wrong spot: #{color_correct}"
      @lives -= 1
      false
    end
  end

  def round 
    win = false
    while @lives.positive?
      win = turn
      break if win
    end
    puts win ? 'Congrats!' : 'Ran out of lives...'
  end
end

Mastermind.new
