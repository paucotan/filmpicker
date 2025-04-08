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

## Usage

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
