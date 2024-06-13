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
	album_artist = music_file.gets
	album_title = music_file.gets
  album_label = music_file.gets
	album_genre = music_file.gets.chomp.to_i
	tracks = read_tracks(music_file)
	album = Album.new( album_artist,album_title, album_label, album_genre, tracks) 
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
	track_name = music_file.gets
	track_location = music_file.gets
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

def display_albums()
  stop = false
  begin
    puts 'Display Albums Menu:'
    puts '1 Display All Albums'
    puts '2 Display Albums by Genre'
    puts '3 Back to Main Menu'
    option = read_integer_in_range("Please enter your choice:", 1, 3)

    case option
    when 1 
      display_all_albums()
    when 2
      display_albums_by_genre()
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
def display_all_albums()
  music_file = read_music_file
  albums=read_albums(music_file)

  music_file.close()
  print_albums(albums)

end

def display_albums_by_genre()
  music_file = read_music_file
  albums=read_albums(music_file)

  search_album = read_integer_in_range('Pick a Genre: ', 1,4)     
  index = 0                  
	while (index < albums.length)
		if (albums[index].genre.to_i == search_album)
			print("#{index}: Title: #{albums[index].title} Artist: #{albums[index].artist} Label: #{albums[index].label} Genre: #{$Genre_names[albums[index].genre.to_i]}\n")
		end
		index= index + 1
	end
end
2
# this is stub code for main menu option 1

def load_albums()
  read_string ('Enter a path to an Album: ')
  music_file = File.new("albums.txt", "r")
  return music_file
end

# complete the case statement below and
# add a stub like the one above for option 2
# of this main menu

#play album for option 3 in Main Menu
def play_album()
  music_file = read_music_file
  albums = read_albums(music_file)
  print_albums(albums)
  puts('Select Album')
  
  select_album = read_integer_in_range('Enter Album number:', 1, albums.length)      
  index = 0                
	while (index < albums.length)
		if (index == select_album -1)
			print("#{index}: Title: #{albums[index].title} Artist: #{albums[index].artist} Label: #{albums[index].label} Genre: #{$Genre_names[albums[index].genre.to_i]}\n")
      print_tracks(albums[index].tracks)
    end
		index= index + 1
	end
end

def main()
  finished = false
  begin
    puts 'Main Menu:'
    puts '1 Read in Albums'
    puts '2 Display Albums'
    puts '3 Select an Album to play'
    puts '5 Exit the application'
    choice = read_integer_in_range("Please enter your choice:", 1, 5)
    case choice
    when 1
      load_albums()
    
    when 2
      display_albums()
 
    when 3 
      play_album()
    when 5
      finished = true
    else
      puts "Please select again"
    end
  end until finished
end


main()
#