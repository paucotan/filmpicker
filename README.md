![FilmPicker Logo](./filmpicker.png)

# FilmPicker 🎬

> **Never know what to watch?** FilmPicker helps you discover movies by genre, explore details, and build your personal watchlist—all from your terminal.

## ✨ What FilmPicker Does

- 🎭 **Browse by Genre** - Explore movies from action to romance
- 📖 **Rich Movie Details** - View ratings, plots, release dates, and more
- ⭐ **Personal Watchlist** - Save favorites for later viewing
- 🚀 **Lightning Fast** - Simple CLI interface, no browser needed

## 🚀 Quick Start

### What You Need
- **Ruby** 2.0+ ([Install Ruby](https://www.ruby-lang.org/en/documentation/installation/))
- **TMDb API Key** - Free from [The Movie Database](https://www.themoviedb.org/settings/api)

### Get Running in 3 Steps

1. **Clone and Setup**
   ```bash
   git clone https://github.com/paucotan/filmpicker.git
   cd filmpicker
   gem install dotenv
   ```

2. **Add Your API Key**
   ```bash
   # Create .env file in project root
   echo "TMDB_API_KEY=your_api_key_here" > .env
   ```

3. **Start Exploring**
   ```bash
   ruby filmpicker.rb
   ```

## 🎯 How to Use

When you run FilmPicker, you'll see three simple options:

1. **🔍 Find a film to watch**
   - Pick a genre (Action, Comedy, Drama, etc.)
   - Browse through movie recommendations
   - View detailed information about any film
   - Save interesting movies to your watchlist

2. **📋 See saved films**
   - Review your personal collection
   - Remove movies you're no longer interested in

3. **🚪 Exit**
   - Close the application

## 💾 Your Watchlist

Movies you save are stored in `saved_movies.json` - your personal film database that persists between sessions.

## 🤝 Contributing

Found a bug? Have an idea? Contributions welcome!

1. Fork the repo
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit changes: `git commit -am 'Add some feature'`
4. Push to branch: `git push origin my-new-feature`
5. Submit a pull request

## 📄 License

MIT License - feel free to use this project however you'd like!