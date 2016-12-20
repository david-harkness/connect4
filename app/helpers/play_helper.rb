module PlayHelper

  def game_rows
    5.downto(0).map do |i|
      game_row(i)
    end.join.html_safe
  end

  private

  def game_row(row_num)
    row = %|<tr class="game-row" id="game-row-#{row_num}">|
    (0..6).map do |i|
      row << game_cel(row_num, i)
    end
    row << "</tr>"
    row
  end

  def game_cel(row, col)
    %|<td id="game-col-#{row}-#{col}" class="game-col"></td>|
  end
end
