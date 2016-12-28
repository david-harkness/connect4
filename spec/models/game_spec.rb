require 'rails_helper'

RSpec.describe Game, type: :model do

  before :each do
    @game = Game.new
  end

  context "Turns" do
    it "Blue has turn 1" do
      expect(@game.blue_turn?).to be_truthy
      expect(@game.red_turn?).to  be_falsey
    end

    it "Turns should alternate" do
      expect(@game.blue_turn?).to be_truthy
      @game.add_token(0)
      expect(@game.red_turn?).to be_truthy
      @game.add_token(0)
      expect(@game.blue_turn?).to be_truthy
    end
  end
  context "Win Conditions" do
    it "should win on 4 blues in a horizontal row" do
      @game.add_token(0) # B
      @game.add_token(0) # R
      @game.add_token(1) # B
      @game.add_token(0) # R
      @game.add_token(2) # B
      @game.add_token(0) # R
      expect(@game.game_won?).to be_falsey # too soon
      @game.add_token(3) # B Game won
      expect(@game.game_won?).to be_truthy
      expect(@game.blue_turn?).to be_truthy
    end

    it "should win on 4 blues in a row" do
      @game.add_token(0) # B
      @game.add_token(1) # R
      @game.add_token(0) # B
      @game.add_token(1) # R
      @game.add_token(0) # B
      @game.add_token(1) # R
      expect(@game.game_won?).to be_falsey # too soon
      @game.add_token(0) # B Game won
      expect(@game.game_won?).to be_truthy
      expect(@game.blue_turn?).to be_truthy
    end

    it "should win on 4 blues in a upward diagonal" do
      @game.add_token(0) # B
      @game.add_token(1) # R
      @game.add_token(1) # B
      @game.add_token(2) # R
      @game.add_token(2) # B
      @game.add_token(3) # R # col 4
      @game.add_token(2) # Blue now has 3 in a row, diag
      @game.add_token(3) # R
      @game.add_token(3) # B
      @game.add_token(6) # R
      expect(@game.game_won?).to be_falsey # too soon
      @game.add_token(3) # B Game won
      expect(@game.game_won?).to be_truthy
      expect(@game.blue_turn?).to be_truthy
    end
  end

  context "After Game" do
    it "should allow a player to keep filling board after a win" do
      @game.add_token(0) # B
      @game.add_token(1) # R
      @game.add_token(0) # B
      @game.add_token(1) # R
      @game.add_token(0) # B
      @game.add_token(1) # R
      expect(@game.game_won?).to be_falsey
      @game.add_token(0) # B Win
      expect(@game.game_won?).to be_truthy
      expect(@game.blue_turn?).to be_truthy
    end
  end

  context "Invalid moves" do
    it "should not allow moves beyond column 7" do
      expect {@game.add_token(7) }.to raise_exception
    end

    it "should not allow more than 6 elements in a column" do
      6.times.each { @game.add_token(0)}
      expect(@game.add_token(0)).to be_falsey
    end
  end

  context "Regression" do
    # Fix for bug reported by Zach
    # nil's in array structure were ignored during win calculation
    it "Gaps between columns should not trigger a win" do
      @game.add_token(0) # B
      @game.add_token(0) # R

      @game.add_token(2) # B
      @game.add_token(2) # R

      @game.add_token(3) # B
      @game.add_token(3) # R

      @game.add_token(4) # B
      @game.add_token(4) # R

      expect(@game.game_won?).to be_falsey
      @game.add_token(1) # B
      expect(@game.game_won?).to be_truthy
    end
  end
end
