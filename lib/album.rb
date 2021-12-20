class Album
  attr_accessor :id, :name


  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({name: name, id: id}))
    end
    albums
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    name = album.fetch("name")
    id = album.fetch("id").to_i
    Album.new({:name => name, :id => id})
  end

  def save
    result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(other_album)
    self.name.eql?(other_album.name)
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end
  
  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};")
  end

  # def self.search(word_searched)
  #   new_array = []
  #   @@albums.values.each do |album|
  #     if album.name == word_searched || album.genre == word_searched || album.year == word_searched || album.artist == word_searched
  #       new_array.push(album)
  #     end
  #   end
  #   new_array
  # end

  # def self.sold(name_searched)
  #   sold_array = []
  #   @@albums.values.each do |album|
  #     if album.name == name_searched
  #       album.sold = true
  #       sold_array.push(album)
  #     end
  #   end
  #   sold_array
  # end

  def self.sort
    returned_albums = DB.exec("SELECT * FROM albums ORDER BY name;")
    albums = []
    returned_albums.each() do |album|
      id = album.fetch("id").to_i
      name = album.fetch("name")
      albums.push(Album.new({name: name, id: id}))
    end
    albums
  end

  def songs
    Song.find_by_album(self.id)
  end
  
end