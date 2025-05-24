#!/usr/bin/env ruby
require 'bundler/setup'
require_relative 'lib/film_picker_app'

FilmPicker::App.new.run
