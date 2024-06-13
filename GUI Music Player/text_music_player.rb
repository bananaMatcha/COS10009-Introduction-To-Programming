require './input_functions'

# It is suggested that you put together code from your 
# previous tasks to start this. eg:
module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$Genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
  attr_accessor :title, :artist, :label, :genre, :tracks
  def initialize (title, artist, label, genre, tracks )
		@title = title
		@artist = artist
    @label = label
    @genre = genre
    @tracks = tracks
	end
end

class Track
	attr_accessor :name, :location
	def initialize (name, location)
		@name = name
		@location = location
	end
end


# Reads in an album from a file and then print the album to the terminal



# 8.1T Read Album with Tracks
#read multiple albums
def read_albums(music_file)
	count = music_file.gets().to_i()
  albums = Array.new()
	index = 0
 	while index < count
		album = read_album(music_file)
		albums << album
		index +=1
	end 
	return albums
end

#read single album
def read_album(music_file)
  album_artist = music_file.gets.chomp()
	album_title = music_file.gets.chomp()
  album_label =  music_file.gets.chomp()
	album_genre = music_file.gets.chomp.to_i
	tracks = read_tracks(music_file)
	album = Album.new( album_title, album_artist, album_label, album_genre, tracks) 
	return album
end

# read multiple tracks from file
def read_tracks(music_file)
  count = music_file.gets().to_i()
  tracks = Array.new()

	index = 0
 	while index < count
		track = read_track(music_file)
		tracks << track
		index +=1
	end 

	return tracks
end

#read single track from file
def read_track(music_file)
	track_name = music_file.gets.chomp()
	track_location = music_file.gets.chomp()
	track = Track.new(track_name, track_location)
  return track
end


#print multiple Tracks
def print_tracks(tracks)
	 index = 0 
   while index < tracks.length 
      puts ("#{index+1} " + 'Track name: ' + tracks[index].name)
      index +=1
  end
end

#print album
def print_albums(albums)
  index = 0 
  while index < albums.length 
    print("#{index+1}: Title: #{albums[index].title} Artist: #{albums[index].artist} Label: #{albums[index].label} Genre: #{$Genre_names[albums[index].genre.to_i]}\n")
    index += 1
  end
end

#5.1T code

def display_albums(albums)
  stop = false
  begin
    print("\n")
    puts 'Display Albums Menu:'
    puts '1 Display All Albums'
    puts '2 Display Albums by Genre'
    puts '3 Back to Main Menu'
    option = read_integer_in_range("Please enter your choice:", 1, 3)

    case option
    when 1 
      display_all_albums(albums)
    when 2
      display_albums_by_genre(albums)
    when 3
      stop = true
    end
  end until stop

end

# implement stub code for each option in the Display Albums menu
def read_music_file ()
  music_file = File.new("albums.txt", "r")
  return music_file
end

def display_all_albums(albums)
  print_albums(albums)
end

def display_albums_by_genre(albums)

  search_album = read_integer_in_range('Pick a Genre: ', 1,4)     
  index = 0                  
	while (index < albums.length)
		if (albums[index].genre.to_i == search_album)
			  print("#{index+1}: Title: #{albums[index].title} Artist: #{albums[index].artist} Label: #{albums[index].label} Genre: #{$Genre_names[albums[index].genre.to_i]}\n")
    end
		index= index + 1
	end
end

# this is stub code for main menu option 1

def load_albums()
  a_file = read_string ('Enter a path to an Album: ')
  music_file = File.new( a_file, "r")
  return music_file
end

# complete the case statement below and
# add a stub like the one above for option 2
# of this main menu

#play album for option 3 in Main Menu
def play_album(albums)
 
  print_albums(albums)
  
  select_album = read_integer_in_range('Select an Album to play: ', 1, albums.length) 
  album = albums[select_album - 1]  #Get the selected album

  index = 0                
	while (index < albums.length)
		if (index == select_album -1)
			print(" Title: #{albums[index].title} Artist: #{albums[index].artist} Label: #{albums[index].label} Genre: #{$Genre_names[albums[index].genre.to_i]}\n")
      print_tracks(album.tracks)
    end
		index= index + 1
	end
  play_track(album)
end

def play_track(album)
   tracks = album.tracks 
   select_track = read_integer_in_range("\n Select a Track to play:", 1, tracks.length)

   index = 0               
	 while (index < tracks.length)
      if (index == select_track -1 )
        puts("Playing track #{tracks[index].name} from album #{album.title}") 
      end
     index +=1
   end
end
def edit_track(album)
   track_name = read_string('Enter a name for the new Track: ')
   track_location = read_string('Enter a new location for the new Track: ')
   track = Track.new(track_name, track_location)
   return track
end
#Option 4 Main menu
def update_album(albums)

  print_albums(albums)

  select_edit_album = read_integer_in_range('Enter the Album to edit: ', 1, albums.length) 
  album = albums[select_edit_album - 1]

  index = 0                
    while (index < albums.length)
      if (index == select_edit_album-1)
        track = edit_track(album)
            
        album.tracks << track   # Add the new track to the album's tracks 
      end
      index +=1
    end
  read_string("New track #{track.name} added to album #{album.title}. Press Enter to continue") 
  return album
  return albums
end

def main()
  

  finished = false
  begin
    print("\n")
    puts 'Main Menu:'
    puts '1 Read in Albums'
    puts '2 Display Albums'
    puts '3 Select an Album to play'
    puts '4 Update an existing Album'
    puts '5 Exit the application'
    choice = read_integer_in_range("Please enter your choice:", 1, 5)
    case choice
    when 1
       music_file = load_albums()
       albums = read_albums(music_file)
    when 2
      display_albums(albums)
 
    when 3 
      play_album(albums)

    when 4
      update_album(albums)

    when 5
      finished = true
    else
      puts "Please select again"
    end
  end until finished
end


main()
#
