require_relative 'movie_api'
require_relative 'movie_storage'
require_relative 'user_interface'

module FilmPicker
  class App
    def initialize
      @api = MovieAPI.new
      @storage = MovieStorage.new
      @ui = UserInterface.new
      @genres = nil
    end
    
    def run
      loop do
        choice = @ui.welcome
        
        case choice
        when 1
          find_movies_by_genre
        when 2
          search_movies
        when 3
          show_saved_movies
        when 4
          @ui.show_message("Goodbye! 🎬", :success)
          break
        end
      end
    rescue Interrupt
      @ui.show_message("\nGoodbye! 🎬", :success)
    rescue => e
      @ui.show_error(e)
      retry
    end
    
    private
    
    def find_movies_by_genre
      genres = load_genres
      return unless genres
      
      loop do
        genre_choice = @ui.display_genres(genres)
        return if genre_choice == :back
        
        selected_genre = genres[genre_choice - 1]
        movies = @api.fetch_movies(selected_genre['id'])
        
        if movies.empty?
          @ui.show_message("No movies found for this genre.", :warning)
          @ui.pause
          next
        end
        
        display_movie_list(movies.sample(10), "Random #{selected_genre['name']} Movies:")
        break
      end
    rescue MovieAPI::APIError => e
      @ui.show_error(e)
    end
    
    def search_movies
      query = @ui.get_search_query
      movies = @api.search_movies(query)
      
      if movies.empty?
        @ui.show_message("No movies found matching '#{query}'.", :warning)
        @ui.pause
        return
      end
      
      display_movie_list(movies[0..9], "Search Results for '#{query}':")
    rescue UserInterface::InputError => e
      @ui.show_error(e)
    rescue MovieAPI::APIError => e
      @ui.show_error(e)
    end
    
    def show_saved_movies
      movies = @storage.load_movies
      
      loop do
        choice = @ui.display_saved_movies(movies)
        return if choice&.downcase == 'b'
        
        if choice&.downcase == 's'
          search_saved_movies
          movies = @storage.load_movies # Refresh list
          next
        end
        
        movie_index = choice.to_i
        if movie_index > 0 && movie_index <= movies.length
          if @ui.confirm_action("Delete '#{movies[movie_index - 1]['title']}'?")
            if @storage.delete_movie(movie_index - 1)
              @ui.show_message("Movie deleted successfully.", :success)
              movies = @storage.load_movies # Refresh list
            else
              @ui.show_message("Failed to delete movie.", :error)
            end
          end
        else
          @ui.show_message("Invalid selection.", :error) unless choice.empty?
        end
      end
    rescue MovieStorage::StorageError => e
      @ui.show_error(e)
    end
    
    def search_saved_movies
      query = @ui.get_search_query
      results = @storage.search_saved_movies(query)
      
      if results.empty?
        @ui.show_message("No saved movies found matching '#{query}'.", :warning)
      else
        @ui.display_movies(results, "Saved Movies matching '#{query}':")
      end
      
      @ui.pause
    rescue UserInterface::InputError => e
      @ui.show_error(e)
    end
    
    def display_movie_list(movies, title)
      loop do
        choice = @ui.display_movies(movies, title)
        return if choice.downcase == 'b'
        
        if choice.downcase == 's'
          search_movies
          return
        end
        
        if choice.downcase == 'r'
          return # Go back to refresh movies
        end
        
        movie_index = choice.to_i
        if movie_index > 0 && movie_index <= movies.length
          show_movie_details(movies[movie_index - 1])
        else
          @ui.show_message("Invalid selection.", :error) unless choice.empty?
        end
      end
    end
    
    def show_movie_details(movie)
      movie_details = @api.fetch_movie_details(movie['id'])
      should_save = @ui.display_movie_details(movie_details, @genres)
      
      if should_save
        if @storage.save_movie(movie_details)
          @ui.show_message("#{movie_details['title']} added to favorites!", :success)
        else
          @ui.show_message("Movie is already in your favorites.", :warning)
        end
        @ui.pause
      end
    rescue MovieAPI::APIError => e
      @ui.show_error(e)
    rescue MovieStorage::StorageError => e
      @ui.show_error(e)
    end
    
    def load_genres
      return @genres if @genres
      
      @genres = @api.fetch_genres
      @genres
    rescue MovieAPI::APIError => e
      @ui.show_error(e)
      nil
    end
  end
end