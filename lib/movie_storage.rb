require 'json'
require 'fileutils'
require_relative '../config'

module FilmPicker
  class MovieStorage
    class StorageError < StandardError; end
    
    def initialize(file_path = Config::MOVIES_FILE)
      @file_path = file_path
      ensure_file_exists
    end
    
    def save_movie(movie)
      validate_movie(movie)
      
      movies = load_movies
      return false if movie_exists?(movies, movie['id'])
      
      movies << sanitize_movie(movie)
      write_movies(movies)
      true
    rescue => e
      raise StorageError, "Failed to save movie: #{e.message}"
    end
    
    def load_movies
      return [] unless File.exist?(@file_path) && !File.zero?(@file_path)
      
      content = File.read(@file_path)
      JSON.parse(content)
    rescue JSON::ParserError => e
      handle_corrupted_file
      []
    rescue => e
      raise StorageError, "Failed to load movies: #{e.message}"
    end
    
    def delete_movie(index)
      movies = load_movies
      return false if index < 0 || index >= movies.length
      
      movies.delete_at(index)
      write_movies(movies)
      true
    rescue => e
      raise StorageError, "Failed to delete movie: #{e.message}"
    end
    
    def movie_count
      load_movies.length
    end
    
    def search_saved_movies(query)
      movies = load_movies
      query_downcase = query.downcase
      
      movies.select do |movie|
        movie['title']&.downcase&.include?(query_downcase) ||
        movie['overview']&.downcase&.include?(query_downcase)
      end
    end
    
    private
    
    def ensure_file_exists
      FileUtils.touch(@file_path) unless File.exist?(@file_path)
      write_movies([]) if File.zero?(@file_path)
    end
    
    def write_movies(movies)
      File.write(@file_path, JSON.pretty_generate(movies))
    end
    
    def validate_movie(movie)
      required_fields = ['id', 'title']
      missing_fields = required_fields - movie.keys
      
      raise StorageError, "Missing required fields: #{missing_fields.join(', ')}" unless missing_fields.empty?
    end
    
    def movie_exists?(movies, movie_id)
      movies.any? { |movie| movie['id'] == movie_id }
    end
    
    def sanitize_movie(movie)
      {
        'id' => movie['id'],
        'title' => movie['title'],
        'release_date' => movie['release_date'],
        'overview' => movie['overview'],
        'vote_average' => movie['vote_average'],
        'poster_path' => movie['poster_path'],
        'genre_ids' => movie['genre_ids'] || movie['genres']&.map { |g| g['id'] },
        'saved_at' => Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')
      }
    end
    
    def handle_corrupted_file
      backup_path = "#{@file_path}.backup.#{Time.now.to_i}"
      FileUtils.cp(@file_path, backup_path) if File.exist?(@file_path)
      write_movies([])
      
      puts "Warning: Corrupted movie file detected and backed up to #{backup_path}".yellow
    end
  end
end