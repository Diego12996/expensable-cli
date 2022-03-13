require "terminal-table"
require "colorized_string"
require "colorize"

module Helpers
  def print_table(title, headings, rows)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = rows
    table.style = { border_x: ColorizedString["-"].colorize(:light_magenta),
                border_y: ColorizedString["|"].colorize(:light_magenta),
                border_i: ColorizedString["+"].colorize(:light_magenta) }
    puts table
  end

  def parse_name(name)
    name.capitalize.to_s
  end

  def parse_date(date)
    date.strftime("%B %Y")
  end

  def intro
    puts "####################################".colorize(:light_magenta)
    puts "#       Welcome to Expensable      #".colorize(:light_magenta)
    puts "####################################".colorize(:light_magenta)
  end

  def exit
    puts "####################################".colorize(:light_magenta)
    puts "#    Thanks for using Expensable   #".colorize(:light_magenta)
    puts "####################################".colorize(:light_magenta)
  end

  def login_form
    email = get_string("email", required: true)
    password = get_string("password", required: true)

    { email: email, password: password }
  end

  def create_form
    loop do
      email = get_string("email", required: true)
      email.match?(/^.*@.+\..+$/) ? break : (puts "Invalid format")
    end
    loop do
      password = get_string("password", required: true)
      password.size >= 6 ? break : (puts "Minimum 6 characters")
    end
    first_name = get_string("First name")
    last_name = get_string("Last name")
    loop do
      phone = get_string("Phone")
      phone.match?(/^(\+\d{2} )*\d{9}$/) ? break : (puts "Required format: +51 111222333 or 111222333")
    end
    { email: email, password: password, first_name: first_name, last_name: last_name, phone: phone }
  end

  def get_with_options(options, options2 = nil)
    puts options.join(" | ").to_s.colorize(:light_cyan)
    puts options2.join(" | ").to_s.colorize(:light_cyan) if options2
    print "> ".colorize(:blue)
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
      print "#{label}: ".colorize(:yellow)
      input = gets.chomp
      break unless input.empty? && required

      puts "Cannot be blank".colorize(:red)
    end
    input
  end

  def form_create_category
    name = get_string("name", required: true)
    transaction_type = nil
    loop do
      transaction_type = get_string("Transaction type", required: true)
      transaction_type.match?(/^(expense|income)$/) ? break : (puts "Only income or expense")
    end
    { name: name, transaction_type: transaction_type }
  end

  def form_add_to_transaction
    form = { amount: nil, date: nil, notes: nil }
    loop do
      form[:amount] = get_string("Amount", required: true).to_i
      form[:amount].zero? ? (puts "Cannot be zero".colorize(:red)) : break
    end
    loop do
      form[:date] = get_string("Date", required: true)
      form[:date].match?(/^\d{4}-\d{2}-\d{2}$/) ? break : (puts "Required format: YYYY-MM-DD".colorize(:red))
    end
    form[:notes] = get_string("Notes")
    form
  end
end
