class Grid
  attr_reader :row_one, :row_two, :row_three

  def initialize(row_one:, row_two:, row_three:)
    @row_one = row_one
    @row_two = row_two
    @row_three = row_three
  end

  def view
    {
      row_one: @row_one,
      row_two: @row_two,
      row_three: @row_three
    }
  end
end
