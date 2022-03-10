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

    { email: email, password: password, first_name: first_name, last_name: last_name, phone: phone}
  end

  def get_with_options(options)
    input = ""

    loop do
      puts options.join (" | ")
      print "> "
      input = gets.chomp
      break if options.include?(input)
      puts "Invalid option"
    end
    input
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
  
end