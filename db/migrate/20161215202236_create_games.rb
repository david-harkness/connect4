class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :player_red_id
      t.integer :player_blue_id
      t.text :games_state
      t.boolean :red_turn

      t.timestamps
    end
  end
end
