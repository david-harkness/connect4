class GameWon < ActiveRecord::Migration[5.0]
  def up 
    add_column :games, :won, :boolean, :default => false
  end
  def down
    drop_column :games, :won
  end
end
