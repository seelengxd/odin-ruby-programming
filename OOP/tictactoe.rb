class Player
  attr_reader :char

  def initialize(char)
    @char = char
  end

  def move
    puts "#{char}: Pick a move [0-8]:"
    Integer(gets.chomp)
  end
end

class Board
  def initialize
    generate_board
  end

  def generate_board
    @grid = Array.new(3) { Array.new(3) }
    @grid.each_with_index do |row, row_index|
      (0..2).each do |col_index|
        row[col_index] = row_index * 3 + col_index
      end
    end
  end

  def play(char, move)
    @grid[move / 3][move % 3] = char
  end

  def display_grid
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |value, col_index|
        print value
        print '|' unless col_index == 2
      end
      print "\n"
      puts '-----' unless row_index == 2
    end
  end

  def available_moves
    @grid.flatten.filter { |value| value.is_a? Numeric }
  end

  def check_win?
    # horizontal
    @grid.each do |row|
      return row[0] if row.all? { |value| value == row[0] }
    end

    # vertical
    (0..2).each do |col_index|
      if @grid[0][col_index] == @grid[1][col_index] && @grid[1][col_index] == @grid[2][col_index]
        return @grid[0][col_index]
      end
    end

    # diagonal
    return @grid[0][0] if @grid[0][0] == @grid[1][1] && @grid[1][1] == @grid[2][2]
    return @grid[0][2] if @grid[0][2] == @grid[1][1] && @grid[1][1] == @grid[2][0]
    return 'TIE' if @grid.flatten.none? { |value| value.is_a? Numeric}
  end
end

test = Board.new
puts test.check_win?

class Game
  def initialize
    @players = {
      X: Player.new('X'),
      O: Player.new('O')
    }
    @board = Board.new
    @turn = :X
  end

  def player_move(player)
    available_moves = @board.available_moves
    print "Pick from #{available_moves}: "
    choice = nil
    until available_moves.include?(choice)
      choice = player.move
      puts 'Invalid. Try again!' unless available_moves.include?(choice)
    end
    choice
  end

  def step
    p @players
    p @turn
    player = @players[@turn]
    @board.display_grid
    choice = player_move(player)
    @board.play(@turn, choice)
    @turn = @turn == :X ? :O : :X
  end

  def round
    step until @board.check_win?
    result = @board.check_win?
    @board.display_grid
    if result == 'TIE'
      puts 'ITS A TIE'
    else
      puts "#{result} wins"
    end
    @board.generate_board
  end
end

game = Game.new
game.round
