![My image](./filmpicker.png)
# FilmPicker 🎬

**FilmPicker** is a simple CLI application built to help you discover movies based on genres. You can search for films, view their details, and even save your favorite films for later. This tool is especially helpful when you're struggling to decide what to watch!

## Features
- **Genre-based movie search**: Select a genre and get a list of films.
- **View movie details**: See the title, release date, overview, and language of the movie.
- **Save your favorites**: Add your favorite movies to a "saved list" and view them later.
- **Easy-to-use CLI**: Simple interface to interact with the app in your terminal.

## Getting Started

### Prerequisites
To run this app locally, you need:
- Ruby (version 2.0 or higher)
- `dotenv` gem for loading environment variables (API keys)
- An active API key for [The Movie Database (TMDb)](https://www.themoviedb.org/). You will need to create a `.env` file with your API key.

### Installation
1. **Clone the repository**:

  ```bash
   git clone https://github.com/yourusername/filmpicker.git
   cd filmpicker
   ```

2. Install dependencies:
If you’re starting with this repo for the first time, make sure to install the required gems.

```bash
gem install dotenv
```

3. Set up the environment file:
	•	Create a .env file in the root of your project folder.
	•	Add your TMDb API key like this:

  TMDB_API_KEY=your_api_key_here

4. Run the app:
In your terminal, run:

```bash
ruby filmpicker.rb
```
The app will prompt you to choose what you’d like to do: find a movie, see your saved movies, or exit.

### Usage

Once you run the application, you will have the following options:
	1.	Find a film to watch: Choose a genre, view a list of movies, and see movie details.
	2.	See saved films: View a list of movies you’ve saved to your favorites.
	3.	Exit: Quit the application.

## Saving Movies

When you select a movie you like, you can choose to add it to your favorites list. This will save the movie’s details to a saved_movies.json file for later reference.

## Contributing

Feel free to fork this project, submit issues, or contribute improvements! Here’s how you can contribute:
	1.	Fork the repository
	2.	Create a feature branch (git checkout -b feature-branch)
	3.	Commit your changes (git commit -am 'Add new feature')
	4.	Push to the branch (git push origin feature-branch)
	5.	Open a pull request on GitHub

## License

This project is licensed under the MIT License
