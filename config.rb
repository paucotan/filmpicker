require 'dotenv/load'

module FilmPicker
  class Config
    TMDB_BASE_URL = 'https://api.themoviedb.org/3'
    MOVIES_FILE = 'saved_movies.json'
    CACHE_DURATION = 300 # 5 minutes in seconds
    MAX_RESULTS_PER_PAGE = 20
    DEFAULT_LANGUAGE = 'en-US'
    
    def self.api_key
      ENV['TMDB_API_KEY'] || raise('TMDB_API_KEY environment variable not set')
    end
    
    def self.genre_url
      "#{TMDB_BASE_URL}/genre/movie/list?api_key=#{api_key}&language=#{DEFAULT_LANGUAGE}"
    end
    
    def self.discover_url(genre_id, page = 1)
      "#{TMDB_BASE_URL}/discover/movie?api_key=#{api_key}&with_genres=#{genre_id}&language=#{DEFAULT_LANGUAGE}&page=#{page}"
    end
    
    def self.movie_details_url(movie_id)
      "#{TMDB_BASE_URL}/movie/#{movie_id}?api_key=#{api_key}&language=#{DEFAULT_LANGUAGE}"
    end
    
    def self.search_url(query, page = 1)
      "#{TMDB_BASE_URL}/search/movie?api_key=#{api_key}&query=#{URI.encode_www_form_component(query)}&language=#{DEFAULT_LANGUAGE}&page=#{page}"
    end
  end
end