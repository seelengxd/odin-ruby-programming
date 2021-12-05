require 'json'

class Hangman
  def initialize
    @words = File.readlines('../5desk.txt').map(&:chomp).filter { |word| word.length >= 5 && word.length < 12 }
    @num_of_words = @words.length
  end

  def new_game
    @word = random_word
    @length = @word.length
    @lives = 5
    @guessed = []
    @display = @length.times.map { '_' }
  end

  def random_word
    @words[rand(@num_of_words)].downcase
  end

  def display
    puts "Lives: #{@lives}"
    puts "Guessed: #{@guessed}"
    puts @display.join(' ')
  end

  def guess_letter(letter)
    if @guessed.include?(letter)
      puts "Already guessed letter #{letter}!"
    elsif @word.include?(letter)
      @word.each_char.with_index { |char, index| @display[index] = letter if letter == char }
      @guessed << letter
    else
      puts "Letter #{letter} is not inside"
      @guessed << letter
      @lives -= 1
    end
  end

  def user_guess
    guess = nil
    until guess&.match(/[a-zA-Z(save)]/)
      puts 'Guess a letter from A-Z. (or Type save to save the game and quit)'
      guess = gets.chomp
      puts 'Invalid guess.' unless guess.match(/[a-zA-Z]/)
    end
    guess.downcase
  end

  def check_win
    @display.none? { |char| char == '_' }
  end

  def play
    until @lives.zero?
      display
      guess = user_guess
      if guess == 'save'
        return save_game
      else
        guess_letter(guess)
        if check_win
          puts 'Congratulations, you won!'
          display
          return menu
        end
      end
    end
    puts 'Better luck next time...'
    puts "Word was: #{@word}"
    menu
  end

  def make_save
    instance_variables.each_with_object({}) do |var, save|
      save[var] = instance_variable_get(var) unless %i[@words @num_of_words].include?(var)
    end
  end

  def choose_save
    File.open('../save.json') do |file|
      save_data = JSON.parse file.read
      choices = save_data.keys.reject { |key| key == "next_index"}
      puts 'Choose a save from...'
      p choices
      chosen = nil
      until choices.include?(chosen)
        puts 'Your choice:'
        chosen = gets.chomp
        puts 'Invalid choice.' unless choices.include?(chosen)
      end
      chosen
    end
  end

  def load_save
    chosen_save = choose_save
    File.open('../save.json') do |file|
      save_data = JSON.parse file.read
      selected = save_data[chosen_save]
      selected.each_key do |key|
        instance_variable_set(key, selected[key])
      end
    end
    play
  end

  def save_game
    data = nil
    File.open('../save.json') do |file|
      data = JSON.parse file.read
      index = data['next_index']
      data[index] = make_save
      data['next_index'] = index + 1
    end
    File.open('../save.json', 'w') do |file|
      file.write(JSON.pretty_generate(data))
    end
  end

  def menu 
    puts '1. Start new game'
    puts '2. Load existing save'
    puts '3. Quit'
    input = gets.chomp until input&.match(/[123]/)
    case input
    when '1'
      new_game
      play
    when '2'
      load_save
    when '3'
      puts 'GOODBYE!'
    end
  end

end



test = Hangman.new
test.menu