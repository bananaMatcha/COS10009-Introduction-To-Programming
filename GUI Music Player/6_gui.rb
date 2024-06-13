require 'rubygems'
require 'gosu'


TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

TrackLeftX= 650

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$Genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

# Put your record definitions here
class Album
	attr_accessor :albumID, :title, :artist, :artwork, :genre, :tracks
	def initialize ( albumID, title, artist, artwork, genre, tracks )
		@albumID = albumID
		@title = title
		@artist = artist
		@artwork = artwork
		@genre = genre
		@tracks = tracks
	end
  end
  
class Track
	attr_accessor  :trackID, :name, :location
	def initialize ( trackID, name, location)
		@trackID = trackID
		@name = name
		@location = location
	end
end


class MusicPlayerMain < Gosu::Window

	def initialize
	    super 1050, 800
	    self.caption = "Music Player"
		@track_font = Gosu::Font.new(23)
	

		@font = Gosu::Font.new(22)

		@albums = []
		@albums = load_albums()
		

		@current_album = 0
		@current_track = 0


		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
	end

  # Put in your code here to load albums and tracks

	
	def load_albums()

	music_file = File.new("music_albums.txt", "r")
	@albums = read_albums(music_file)
	music_file.close()
	return @albums
	end

	def read_track(music_file, trackID)
		track_ID = trackID
		track_name = music_file.gets.chomp()
		track_location = music_file.gets.chomp()

		track = Track.new(track_ID, track_name, track_location)

		return track
	end

	def read_tracks(music_file)
		count = music_file.gets().to_i()
		tracks = []
			index = 0
			while index < count
				track = read_track(music_file, index + 1)
				tracks << track
				index +=1 
			end 
		return tracks
	end

	#read single album
	def read_album(music_file, albumID )
		album_ID = albumID
		album_artist = music_file.gets.chomp()
		album_title = music_file.gets.chomp()
		album_artwork = music_file.gets.chomp()
		album_genre = music_file.gets.chomp.to_i
		tracks = read_tracks(music_file)

		album = Album.new( album_ID, album_title, album_artist, album_artwork, album_genre, tracks) 

		return album
	end


	def read_albums(music_file)
		count = music_file.gets().to_i()
		@albums =[]
		index = 0
		while index < count
			album = read_album(music_file, index +1)
			@albums << album
			index +=1
		end 
		return @albums
	end

  # Draws the artwork on the screen for all the albums

  def draw_albums ()
    # complete this code
	x = 10
	y = 50
	i = 0
	while i < @albums.length
		@bmp = Gosu::Image.new(@albums[i].artwork)
		@bmp.draw(x, y, ZOrder::PLAYER)

		x += 320  # Adjust the horizontal spacing
		if x > 600
			y +=320 #Move to the next row
			x = 10
		end
        i+=1
	end
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false
  def area_clicked(mouse_x, mouse_y)
	
	if (mouse_y > 50 && mouse_y < 350)
		if (mouse_x > 0 && mouse_x < 310)
			@current_album = 1
		elsif (mouse_x > 330 && mouse_x < 630)
			@current_album = 2
		end
	
	elsif (mouse_y > 350 && mouse_y < 670)
		if (mouse_x > 0 && mouse_x < 310)
			@current_album = 3
		elsif (mouse_x > 330 && mouse_x < 630)
			@current_album = 4
		end
	else
		@current_album = 0 
	end	

	 	
  end  
  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(albums)
	x = 700
	y = 250  # Adjust the vertical position to show tracks below the albums
	i = 0
	album = @albums[@current_album - 1]

		if @current_album > 0 && @current_album <= @albums.length

		album = @albums[@current_album - 1]
		@track_font.draw_text("Track List: ", 650, 200, ZOrder::UI, 1.0, 1.0, Gosu::Color::GREEN)
		while i < album.tracks.length
			track = album.tracks[i]
			@track_font.draw_text(track.name.chomp, x, y, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
			
			if @current_track  == i
				@track_font.draw_text(track.name.chomp, x, y, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
			else
				@track_font.draw_text(track.name.chomp, x, y, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
			end

			y += 50  # Adjust the vertical spacing between track titles
			i += 1
		end
	end
  end


  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track, album)
	@song = Gosu::Song.new(@albums[album-1].tracks[track].location)
	@song.play(false)
  end



	def draw_background ()
		draw_quad(0,0, TOP_COLOR, 0, 800, TOP_COLOR, 1050, 0, BOTTOM_COLOR, 1050, 800, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
	end
	def update()

	
	end	
 # Draws the album images and the track list for the selected album

 def draw

	albums = @albums
	x = 700
	y = 100
	draw_albums()
	draw_background()
	
	if @current_album != 0 
	  display_album_details(albums[@current_album-1])
	
		i = 0
		while i < albums[@current_album-1].tracks.length
		 
		  display_track(albums[@current_album - 1])
		  if (@albums[@current_album-1].tracks[i].trackID == @current_track+1 )
			
			@font.draw("Now Playing: #{@albums[@current_album-1].tracks[i].name}", 700,500, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
		  end
		  i += 1
		end
	  
	end
	draw_highlight_album(@current_album)
  end
  	
	def display_album_details (album)
		album =  @albums[@current_album-1]
		@track_font.draw_text("Title: #{album.title}", TrackLeftX, 50, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
		@track_font.draw_text("Artist: #{album.artist}", TrackLeftX, 100, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
		@track_font.draw_text("Genre: #{$Genre_names[album.genre.to_i()]}", TrackLeftX, 150, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
	end
	
	def draw_highlight_album (current_album)
		case @current_album 
		when 1
			Gosu.draw_rect(0, 40, 320, 320,  Gosu::Color::YELLOW, ZOrder::BACKGROUND, mode=:default)
		when 2
			Gosu.draw_rect(320, 40, 320, 320,  Gosu::Color::YELLOW, ZOrder::BACKGROUND, mode=:default)
		when 3
			Gosu.draw_rect(0, 360, 320, 320,  Gosu::Color::YELLOW, ZOrder::BACKGROUND, mode=:default)
		when 4
			Gosu.draw_rect(320, 360, 320, 320,  Gosu::Color::YELLOW, ZOrder::BACKGROUND, mode=:default)
		end
	end
	def select_track()
		if (mouse_x > 700 && mouse_x < 1050) 
			if (mouse_y > 300 && mouse_y < 320) #250 + 23 + 50/2
				return @current_track = 1 
			elsif (mouse_y > 320 && mouse_y < 380)
				return @current_track = 2
			elsif (mouse_y > 400 && mouse_y < 460)
				return @current_track = 3
			elsif (mouse_y > 460 && mouse_y < 470)
				return @current_track = 4
			elsif (mouse_y > 470 && mouse_y < 520)
				return @current_track = 5 
			else
				@current_track = 0
			end
		end
	end

 	def needs_cursor?; true; end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
	# you will learn about inheritance in the OOP unit - for now just accept that
	# these are available and filled with the latest x and y locations of the mouse click.
 

	def button_down(id)
		case id
	    when Gosu::MsLeft
                # What should happen here
				area_clicked(mouse_x, mouse_y) 
				if @current_album !=0
					select_track()
					playTrack(@current_track, @current_album)
				else
					@song.stop
				end
				
			end
		end

end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
