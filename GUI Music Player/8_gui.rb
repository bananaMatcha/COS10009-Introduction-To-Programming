require 'rubygems'
require 'gosu'


TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
WIDTH = 1000
HEIGHT = 800
TrackLeftX = 650 #track location

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

$Genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp
	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end
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

class Song
	attr_accessor :song

	def initialize (file)
		@song = Gosu::Song.new(file)
	end
end

class MusicPlayerMain < Gosu::Window
	def initialize
	    super WIDTH, HEIGHT
	    self.caption = "Music Player"
		@track_font = Gosu::Font.new(25)
    
		@current_album = nil
		@current_tracks = nil
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
   
  # Draw the artwork on the screen for all the albums
  def draw_albums()
	music_file = File.new('music_albums.txt', "r")
	albums = read_albums(music_file)
	music_file.close()
    x = 10
	y = 50
	i = 0
	while i < albums.length
		@bmp = Gosu::Image.new(albums[i].artwork)
		@bmp.draw(x, y, ZOrder::PLAYER)

		x += 320  # Adjust the horizontal spacing
		if x > 600
			
			y +=320 #Move to the next row
			x = 10
	
		end
        i+=1
	end

	# Highlight the selected album
	if (@current_album == 1 or ((mouse_x > 10 and mouse_x < 310) and (mouse_y > 10 and mouse_y < 310)))
		Gosu.draw_rect(8, 8, 304, 304, Gosu::Color::YELLOW, ZOrder::PLAYER, mode=:default)
	end
	if (@current_album == 2 or ((mouse_x > 10 and mouse_x < 310) and (mouse_y > 320 and mouse_y < 620)))
		Gosu.draw_rect(8, 318, 304, 304, Gosu::Color::YELLOW, ZOrder::PLAYER, mode=:default)
	end
	if (@current_album == 3 or ((mouse_x > 320 and mouse_x < 620) and (mouse_y > 10 and mouse_y < 310)))
		Gosu.draw_rect(318, 8, 304, 304, Gosu::Color::YELLOW, ZOrder::PLAYER, mode=:default)
	end
	if (@current_album== 4 or ((mouse_x > 320 and mouse_x < 620) and (mouse_y > 320 and mouse_y < 620)))
		Gosu.draw_rect(318, 318, 304, 304, Gosu::Color::YELLOW, ZOrder::PLAYER, mode=:default)
	end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR
	def draw_background
		draw_quad(0, 0, TOP_COLOR, 
				  WIDTH, 0, TOP_COLOR, 
				  0, HEIGHT, BOTTOM_COLOR, 
				  WIDTH, HEIGHT, BOTTOM_COLOR, 
				  ZOrder::BACKGROUND)
	end

	def draw()
		draw_background()
		draw_albums()
		
		if @current_tracks != nil	# Draw the track list for the selected album
			display_album(@current_album)
			ypos = 250
			@current_tracks.each do |track|
				display_tracks(track, ypos)
				ypos += 50
			end
		end

		if @played_track # Highlight the track being played
			@track_font.draw_text("Now playing: #{@played_track.name}", TrackLeftX, 450, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
			
		end
	end

	def display_albums()
		music_file = File.new('music_albums.txt', "r")
		albums = read_albums(music_file)
		music_file.close()
		@selected_album = albums[@current_album - 1]
		@current_tracks = @current_album.tracks
	end

	def display_album(album)
		@track_font.draw_text(album.title, TrackLeftX, 10, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::RED)
		@track_font.draw_text("Artist: #{album.artist}", TrackLeftX, 60, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::RED)
	
		@track_font.draw_text("Genre: #{$genre_names[album.genre.to_i()]}", TrackLeftX, 160, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::RED)
	end

	def display_tracks(track, ypos)
		@track_font.draw_text(track.name, TrackLeftX, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
	end

 	def needs_cursor? 
		true 
	end

	def button_down(id)
		case id
	    when Gosu::MsLeft
	    	# Display selected album's information and tracks
			if ((mouse_x > 10 and mouse_x < 310) and (mouse_y > 10 and mouse_y < 310))
				@selected_album = 1
				display_albums()
			elsif ((mouse_x > 10 and mouse_x < 310) and (mouse_y > 320 and mouse_y < 620))
				@selected_album = 2	
				display_albums()			
			elsif ((mouse_x > 320 and mouse_x < 620) and (mouse_y > 10 and mouse_y < 310))
				@selected_album = 3
				display_albums()				
			elsif ((mouse_x > 320 and mouse_x < 620) and (mouse_y > 320 and mouse_y < 620))
				@selected_album = 4	
				display_albums()		
			elsif @selected_album != nil
	
			end
		end
	end

	# Detects if a 'mouse sensitive' area has been clicked on and returns the selected track's index
	def button_functions()
		select_track()
		sound_setting()
		
	end

	def select_track() # Choose a track to play
		if ((mouse_x > 650 and mouse_x < 1200) and (mouse_y > 250 and mouse_y < 290))
			@track = 0
			playTrack(@track, @current_album)
		elsif ((mouse_x > 650 and mouse_x < 1200) and (mouse_y > 300 and mouse_y < 340))
			@track = 1
			playTrack(@track, @current_album)
		elsif ((mouse_x > 650 and mouse_x < 1200) and (mouse_y > 350 and mouse_y < 390))
			@track = 2
			playTrack(@track, @current_album)
		end
		return @track
	end

	# Takes a track index and an Album and plays the Track from the Album
	def playTrack(track, album)
		@played_track = album.tracks[track]
		if @song # stop any song being played
			@song.stop()
		end
		@song = Gosu::Song.new(@played_track.location)
		@song.play(false)
   	end

	

end

# Show is a method that loops through update and draw
MusicPlayerMain.new.show if __FILE__ == $0