require_relative "sessions"

class Expensable
  def initialize
    @user = nil
    @notes = []
  end

  def intro
    puts "####################################"
    puts "#       Welcome to Expensable      #"
    puts "####################################"
  end

  def main_menu
    intro
    action = ""

    until action == "exit"
      action = get_with_options(["login", "create_user", "exit"])
      begin
        case action
        when "login"
          login
        when "create_user"
          puts "execute create user"
        when "exit"
          puts "Thanks"
        end
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error
      end
    end
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

  def login
    credentials = login_form
    @user = Sessions.login(credentials)
  end

  def login_form
    print "username: "
    username = gets.chomp

    print "password: "
    password = gets.chomp

    {username: username, password: password}
  end

end

prueba = Expensable.new
prueba.main_menu
