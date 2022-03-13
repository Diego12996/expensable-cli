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
    name.capitalize.to_s
  end

  def parse_date(date)
    date.strftime("%B %Y")
  end

  def intro
    puts "####################################"
    puts "#       Welcome to Expensable      #"
    puts "####################################"
  end

  def exit
    puts "####################################"
    puts "#    Thanks for using Expensable   #"
    puts "####################################"
  end

  def login_form
    email = get_string("email", required: true)
    password = get_string("password", required: true)

    { email: email, password: password }
  end

  def create_form
    email = get_string("email", required: true)
    password = get_string("password", required: true)
    first_name = get_string("First name")
    last_name = get_string("Last name")
    phone = get_string("Phone")

    { email: email, password: password, first_name: first_name, last_name: last_name, phone: phone }
  end

  def get_with_options(options, options2 = nil)
    puts options.join(" | ").to_s
    puts options2.join(" | ").to_s if options2
    print "> "
    action, id = gets.chomp.split
    id.nil? ? action : [action, id]
  end

  def login_menu
    get_with_options(["login", "create_user", "exit"])
  end

  def account_menu
    get_with_options(["create", "show ID", "update ID", "delete ID"],
                     ["add-to ID", "toggle", "next", "prev", "logout"])
  end

  def category_menu
    get_with_options(["add", "update ID", "delete ID"],
                     ["next", "prev", "back"])
  end

  def get_string(label, required: false)
    input = ""

    loop do
      print "#{label}: "
      input = gets.chomp
      break unless input.empty? && required

      puts "Can't be blank"
    end
    input
  end

  def form_add_to_transaction
    form = { amount: nil, date: nil, notes: nil }
    loop do
      form[:amount] = get_string("Amount", required: true).to_i
      form[:amount].zero? ? (puts "Cannot be zero") : break
    end
    loop do
      form[:date] = get_string("Date", required: true)
      form[:date].match?(/^\d{4}-\d{2}-\d{2}$/) ? break : (puts "Required format: YYYY-MM-DD")
    end
    form[:notes] = get_string("Notes")
    form
  end
end
