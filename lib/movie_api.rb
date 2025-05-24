require 'net/http'
require 'json'
require 'uri'
require_relative '../config'

module FilmPicker
  class MovieAPI
    class APIError < StandardError; end
    class RateLimitError < APIError; end
    
    def initialize
      @cache = {}
      @last_request_time = Time.now - 1
    end
    
    def fetch_genres
      cache_key = 'genres'
      return @cache[cache_key][:data] if cache_valid?(cache_key)
      
      response = make_request(Config.genre_url)
      genres = response['genres']
      @cache[cache_key] = { data: genres, timestamp: Time.now }
      genres
    rescue => e
      raise APIError, "Failed to fetch genres: #{e.message}"
    end
    
    def fetch_movies(genre_id, page = 1)
      cache_key = "movies_#{genre_id}_#{page}"
      return @cache[cache_key][:data] if cache_valid?(cache_key)
      
      response = make_request(Config.discover_url(genre_id, page))
      movies = response['results'] || []
      @cache[cache_key] = { data: movies, timestamp: Time.now }
      movies
    rescue => e
      raise APIError, "Failed to fetch movies: #{e.message}"
    end
    
    def fetch_movie_details(movie_id)
      cache_key = "movie_#{movie_id}"
      return @cache[cache_key][:data] if cache_valid?(cache_key)
      
      response = make_request(Config.movie_details_url(movie_id))
      @cache[cache_key] = { data: response, timestamp: Time.now }
      response
    rescue => e
      raise APIError, "Failed to fetch movie details: #{e.message}"
    end
    
    def search_movies(query, page = 1)
      cache_key = "search_#{query}_#{page}"
      return @cache[cache_key][:data] if cache_valid?(cache_key)
      
      response = make_request(Config.search_url(query, page))
      movies = response['results'] || []
      @cache[cache_key] = { data: movies, timestamp: Time.now }
      movies
    rescue => e
      raise APIError, "Failed to search movies: #{e.message}"
    end
    
    private
    
    def make_request(url)
      rate_limit
      
      uri = URI(url)
      response = Net::HTTP.get_response(uri)
      
      case response.code
      when '200'
        JSON.parse(response.body)
      when '429'
        raise RateLimitError, 'API rate limit exceeded'
      when '401'
        raise APIError, 'Invalid API key'
      else
        raise APIError, "HTTP #{response.code}: #{response.message}"
      end
    rescue JSON::ParserError
      raise APIError, 'Invalid JSON response from API'
    rescue Net::TimeoutError
      raise APIError, 'Request timeout'
    rescue SocketError
      raise APIError, 'Network connection error'
    end
    
    def rate_limit
      time_since_last = Time.now - @last_request_time
      sleep(0.25 - time_since_last) if time_since_last < 0.25
      @last_request_time = Time.now
    end
    
    def cache_valid?(key)
      cached = @cache[key]
      return false unless cached
      
      Time.now - cached[:timestamp] < Config::CACHE_DURATION
    end
  end
end