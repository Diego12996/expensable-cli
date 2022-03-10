require "terminal-table"

module Helpers
  def print_table(title, headings, rows)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = rows
    puts table
  end

  def parse_name(name)
    "#{name.capitalize}"
  end
  
  def parse_date(date)
    date.strftime("%B %Y")
  end
end