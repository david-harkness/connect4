class Game < ApplicationRecord

  # Not using players for now, as it's not important to core game mechanics
  #belongs_to :blue_user, foreign_key: 'player_blue_id', :class_name => User
  #belongs_to :red_user, foreign_key: 'player_red_id', :class_name => User

  before_save :save_game_state

  # 1 array for each column
  def default_board
    [ [], [], [], [], [], [], [] ]
  end

  def game
    @game
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
  def up_diag(x,y)
    (0..3).map do |i|
      @game[x + i][y +i]
    end.join
  end
  def down_diag(x,y)
    3.downto(0).map do |i|
      @game[x + i][y -i]
    end.join
  end


  def check_diagonals
    array = []
    (0..3).each do |x| # Only makes since to start from first 4 columns
      (0..2).each do |y| # Only makes since to start from first 3 rows
        array << up_diag(x,y)
      end
    end

    (0..3).each do |x| # Only makes since to start from first 4 columns
      6.downto(0).each do |y|
        array << down_diag(x,y)
      end
    end

    array.each do |item|
      return true if item.match(/bbbb|rrrr/)
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
      return true if c.join.match(/bbbb|rrrr/)
    end
    false
  end

  def check_columns
    # Look for 4 items in a row
    @game.each do |c|
      return true if c.join.match(/bbbb|rrrr/)
    end
    false
  end
end
