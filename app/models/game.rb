class Game < ApplicationRecord

  # Not using players for now, as it's not important to core game mechanics
  #belongs_to :blue_user, foreign_key: 'player_blue_id', :class_name => User
  #belongs_to :red_user, foreign_key: 'player_red_id', :class_name => User

  before_save :save_game_state

  attr :game

  # 1 array for each column
  def default_board
    [ [], [], [], [], [], [], [] ]
  end


  def load_game
    if games_state
      @game = JSON.parse(games_state)
    else
      @game = default_board
    end
  end

  def save_game_state
    load_game if @game.nil?
    self.games_state = @game
  end

  def add_token(col)
    load_game if @game.nil?
    errors.add(:Move, "Invalid Column") if col > 6
    errors.add(:Move, "Column Full")    if @game[col].size > 5
    return false if errors.any?

    @game[col] << (self.red_turn ? 'r': 'b')

    self.won = game_won?
    return true if won # Don't flip player, so we know who won.

    self.red_turn = !self.red_turn
    true
  end

  def game_won?
    load_game if @game.nil?
    # Check Columns
    return true if check_columns
    return true if check_rows
    return true if check_diagonals
    false
  end

  private

  def diag_up(x,y)
    (0..3).map do |i|
      @game[x + i][y +i]
    end
  end

  def diag_down(x,y)
    (0..3).map do |i|
      #puts "x,y =#{x}, #{y}, xi,yi = #{x + i}, #{y -i}, gb = #{@game[x + i][y - i]}"
      @game[x + i][y - i]
    end
  end

  def check_diagonals
    array = []

    (0..3).each do |x| # Only makes sense to start from first 4 columns
      (0..2).each do |y| # Only makes sense to start from first 3 rows
        array << diag_up(x,y)
      end
    end

    (0..3).each do |x| # Only makes sense to start from first 4 columns
      5.downto(3).each do |y| # Only makes sense to start from first 3 rows
        array << diag_down(x,y)
      end
    end

    #return if any condition is true
    array.each do |item|
      return true if check_for_match(item)
    end
    false
  end

  def check_rows
    # Flip rows into columns, for fast check
    array = []
    (0..5).each do |x|
      tmp_array = []
      (0..6).each do |y|
        tmp_array << @game[y][x]
      end
      array << tmp_array
    end
    array.each do |c|
      return true if check_for_match(c)
    end
    false
  end

  def check_columns
    # Look for 4 items in a row
    @game.each do |c|
      return true if check_for_match(c)
    end
    false
  end

  # check if we have 4 in a row from an array
  # ["b", nil, "b", "b", "b", nil, nil]
  def check_for_match(item)
    # Replace nil's with spaces, so match works
    item.map{|x| x.nil? ? ' ' : x}.join.match(/bbbb|rrrr/)
  end
end
