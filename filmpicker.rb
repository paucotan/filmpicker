require 'net/http'
require 'json'
require 'dotenv/load'

TMDB_API_KEY = ENV['TMDB_API_KEY']

def welcome
  puts ""
  puts "--------------------------------"
      puts "Welcome to FilmPicker 🎬"
  puts "--------------------------------"

  puts "What would you like to do?
  1. Find a film to watch
  2. See saved films
  3. Exit
  Enter your choice:"
  choice = gets.chomp.to_i
  return choice
end

def handle_user_choice(choice)
  case choice
  when 1
    puts "You chose to find a film to watch."
    genre_id = select_genres
    movies = fetch_movies(genre_id).sample(10)
    display_movies(movies)
  when 2
    show_saved
  when 3
    puts "Goodbye!"
    exit
  else
    puts "Invalid choice. Please try again."
  end
end

def fetch_genres
  uri = URI("https://api.themoviedb.org/3/genre/movie/list?api_key=#{TMDB_API_KEY}&language=en-US")
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  # puts data
  data["genres"]
end

def fetch_movies(genre_id)
  uri = URI("https://api.themoviedb.org/3/discover/movie?api_key=#{TMDB_API_KEY}&with_genres=#{genre_id}&language=en-US")
  response = Net::HTTP.get(uri)
  JSON.parse(response)["results"]
end

def fetch_movie_details(movie_id)
  uri = URI("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{TMDB_API_KEY}&language=en-US")
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

def select_genres
  genres = fetch_genres
  puts "Select the genre you want to watch:"
  genres.each_with_index do |genre, index|
    puts "#{index + 1}. #{genre['name']}"
  end

  puts "Enter the number of the genre you want to watch:"
  genre_number = gets.chomp.to_i
  genre_id = genres[genre_number - 1]["id"]
  return genre_id
end

def display_movies(movies)
  puts "\nHere are 10 random movies you might enjoy:"
  movies.each_with_index do |movie, index|
    puts "#{index + 1}. #{movie["title"]} (#{movie["release_date"]})"
    puts ""  # Add line break for readability
  end

  puts "Enter the index number of the movie you'd like to know more about, or press 0 to skip."
  movie_index = gets.chomp.to_i

  if movie_index > 0 && movie_index <= movies.length
    movie_details = fetch_movie_details(movies[movie_index - 1]["id"])
    show_movie_details(movie_details)
  else
    puts "No movie selected."
  end
end

def show_movie_details(details)
  puts "\nMovie Details:"
  puts "Title: #{details["title"]}"
  puts "Release Date: #{details["release_date"]}"
  puts "Overview: #{details["overview"]}"
  # puts "Director: #{details["credits"]["crew"].find { |c| c["job"] == "Director" }["name"]}"
  puts "Language: #{details["original_language"]}"
  puts "\nWould you like to add this movie to your favorites? (y/n)"
  answer = gets.chomp.downcase
  save_movie(details) if answer == 'y'
end

def save_movie(movie)
  File.open('saved_movies.json', 'a') do |file|
    file.puts JSON.generate(movie)
  end
  puts "#{movie['title']} has been added to your favorites."
end

def show_saved
  puts "\nSaved Movies:"
  puts ""

  if File.exist?('saved_movies.json') && !File.zero?('saved_movies.json')
    File.readlines('saved_movies.json').each_with_index do |line, index|
      movie = JSON.parse(line)
      puts "#{index + 1}. #{movie['title']} (#{movie['release_date']})"
    end
    puts "---------------"
    puts "Would you like to delete any of these films? \nEnter the number of the movie, or press 0 to skip."
    movie_index = gets.chomp.to_i

    if movie_index > 0 && movie_index <= File.readlines('saved_movies.json').size
      lines = File.readlines('saved_movies.json')
      lines.delete_at(movie_index - 1)
      File.open('saved_movies.json', 'w') { |file| file.puts lines }
      puts "Movie deleted successfully."
    else
      puts "No movie selected."
    end
  else
    puts "You have no saved movies."
  end
end

# Function to delete a saved movie
def delete_saved
  puts "\nSaved Movies:"
  puts ""

  # Check if the file exists and is not empty
  if File.exist?('saved_movies.json') && !File.zero?('saved_movies.json')
    File.readlines('saved_movies.json').each_with_index do |line, index|
      movie = JSON.parse(line)
      puts "#{index + 1}. #{movie['title']} (#{movie['release_date']})"
    end

    puts "Enter the number of the movie you want to delete, or press 0 to skip."
    movie_index = gets.chomp.to_i

    if movie_index > 0 && movie_index <= File.readlines('saved_movies.json').size
      lines = File.readlines('saved_movies.json')
      lines.delete_at(movie_index - 1)
      File.open('saved_movies.json', 'w') { |file| file.puts lines }
      puts "Movie deleted successfully."
    else
      puts "No movie selected."
    end
  else
    puts "You have no saved movies."
  end
end
loop do
  choice = welcome
  handle_user_choice(choice)
  break if choice == 3
end
