require 'colorize'
require 'date'

module FilmPicker
  class UserInterface
    class InputError < StandardError; end
    
    def initialize
      @navigation_stack = []
    end
    
    def welcome
      clear_screen
      puts ""
      puts "--------------------------------".yellow
      puts "Welcome to FilmPicker 🎬".green.bold
      puts "--------------------------------".yellow
      puts "What would you like to do?".cyan
      puts "1. Find a film to watch"
      puts "2. Search for a specific movie"
      puts "3. See saved films"
      puts "4. Exit"
      puts "Enter your choice:".cyan
      
      choice = get_integer_input(1..4)
      choice
    end
    
    def display_genres(genres)
      puts "\nSelect the genre you want to watch:".green
      genres.each_with_index do |genre, index|
        puts "#{index + 1}. #{genre['name'].cyan}"
      end
      
      puts "\nEnter the number of the genre (or 'b' to go back):".yellow
      input = gets
      return :back if input.nil?
      input = input.chomp.strip
      return :back if input.downcase == 'b'
      
      choice = input.to_i
      return choice if choice > 0 && choice <= genres.length
      
      raise InputError, "Invalid genre selection"
    end
    
    def display_movies(movies, title = "Here are movies you might enjoy:")
      puts "\n#{title}".green
      puts "=" * title.length
      
      movies.each_with_index do |movie, index|
        rating = movie['vote_average'] ? " ⭐ #{movie['vote_average']}/10" : ""
        year = movie['release_date'] ? " (#{movie['release_date'][0..3]})" : ""
        puts "#{index + 1}. #{movie['title'].cyan}#{year}#{rating}"
      end
      
      puts "\nOptions:".yellow
      puts "• Enter movie number to view details"
      puts "• 's' to search for a specific movie"
      puts "• 'r' to refresh/get more movies"
      puts "• 'b' to go back"
      puts "Enter your choice:".yellow
      
      input = gets
      return 'b' if input.nil?
      input.chomp.strip
    end
    
    def display_movie_details(movie, genres = [])
      clear_screen
      puts "\n" + "=" * 50
      puts "MOVIE DETAILS".green.bold.center(50)
      puts "=" * 50
      
      puts "Title: #{movie['title'].cyan.bold}"
      puts "Release Date: #{movie['release_date'] || 'Unknown'}"
      puts "Rating: ⭐ #{movie['vote_average'] || 'N/A'}/10"
      puts "Runtime: #{format_runtime(movie['runtime'])}" if movie['runtime']
      
      if movie['genres'] && !movie['genres'].empty?
        genre_names = movie['genres'].map { |g| g['name'] }.join(', ')
        puts "Genres: #{genre_names.yellow}"
      end
      
      puts "\nOverview:".green
      puts word_wrap(movie['overview'] || 'No overview available', 70)
      
      puts "\n" + "-" * 50
      puts "Would you like to:".yellow
      puts "1. Add to favorites"
      puts "2. Go back"
      
      choice = get_integer_input(1..2)
      choice == 1
    end
    
    def display_saved_movies(movies)
      if movies.empty?
        puts "\nYou have no saved movies.".red
        puts "Press any key to continue..."
        input = gets
        return nil
      end
      
      puts "\nSaved Movies:".green.bold
      puts "=" * 20
      
      movies.each_with_index do |movie, index|
        rating = movie['vote_average'] ? " ⭐ #{movie['vote_average']}/10" : ""
        year = movie['release_date'] ? " (#{movie['release_date'][0..3]})" : ""
        saved_date = movie['saved_at'] ? " [#{Date.parse(movie['saved_at']).strftime('%m/%d/%y')}]" : ""
        puts "#{index + 1}. #{movie['title'].cyan}#{year}#{rating}#{saved_date.light_black}"
      end
      
      puts "\nOptions:".yellow
      puts "• Enter movie number to delete"
      puts "• 's' to search saved movies"
      puts "• 'b' to go back"
      puts "Enter your choice:".yellow
      
      input = gets
      return 'b' if input.nil?
      input.chomp.strip
    end
    
    def get_search_query
      puts "\nEnter movie title to search for:".green
      input = gets
      return "" if input.nil?
      query = input.chomp.strip
      raise InputError, "Search query cannot be empty" if query.empty?
      query
    end
    
    def confirm_action(message)
      puts "#{message} (y/n):".yellow
      input = gets
      return false if input.nil?
      response = input.chomp.strip.downcase
      %w[y yes].include?(response)
    end
    
    def show_message(message, type = :info)
      color = case type
              when :success then :green
              when :error then :red
              when :warning then :yellow
              else :white
              end
      
      puts message.colorize(color)
    end
    
    def show_error(error)
      puts "\nError: #{error.message}".red
      puts "Press any key to continue..."
      input = gets
      return if input.nil?
    end
    
    def pause(message = "Press any key to continue...")
      puts message.light_black
      input = gets
      return if input.nil?
    end
    
    private
    
    def clear_screen
      system('clear') || system('cls')
    end
    
    def get_integer_input(range)
      loop do
        input = gets
        return 4 if input.nil? # Exit gracefully if no input (EOF)
        
        input = input.chomp.strip
        number = input.to_i
        
        return number if range.include?(number)
        
        puts "Please enter a number between #{range.first} and #{range.last}:".red
      end
    end
    
    def word_wrap(text, line_width)
      text.split("\n").map do |line|
        line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
      end.join("\n")
    end
    
    def format_runtime(minutes)
      return "Unknown" unless minutes&.positive?
      
      hours = minutes / 60
      mins = minutes % 60
      
      if hours > 0
        "#{hours}h #{mins}m"
      else
        "#{mins}m"
      end
    end
  end
end