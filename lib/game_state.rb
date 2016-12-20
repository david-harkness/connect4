require 'pp'
gameboard = [
    [],
    [],
    [],
    [],
    [],
    [], []]


class GameState

  def initialize(gameboard)
    @gb= gameboard # Assume it's not still in JSON
  end


  def to_json
    @gb.to_json
  end

  def add_token(col)
    raise "Error: Invalid Column" if col > 6
    raise "Error: Column #{col} Full"    if @gb[col].size > 5
    # Add check if column is full
    @gb.red_turn = !@gb.red_turn
    @gb[col]
  end

  def display_board
    pp @gb

  end
end

# add check if this is called directly so we don't run
game= GameState.new(gameboard)
game.add_column(0,'b')
game.add_column(0,'r')
game.add_column(0,'b')
game.add_column(0,'r')
game.add_column(0,'b')
game.add_column(0,'r')
game.display_board




