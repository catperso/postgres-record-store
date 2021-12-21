class Album
  attr_accessor :id, :name, :year, :price


  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
    @year = attributes[:year]
    @price = attributes[:price]
  end

  def self.all
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      year = album.fetch("year").to_i
      price = album.fetch("price").to_i
      albums.push(Album.new({name: name, id: id, year: year, price: price}))
    end
    albums
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    name = album.fetch("name")
    id = album.fetch("id").to_i
    year = album.fetch("year").to_i
    price = album.fetch("price").to_i
    Album.new({:name => name, :id => id, year: year, price: price})
  end

  def save
    result = DB.exec("INSERT INTO albums (name, year, price) VALUES ('#{@name}', '#{@year}', '#{@price}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(other_album)
    self.name.eql?(other_album.name)
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end
  
  def update(name, year, price)
    @name = name
    @year = year
    @price = price
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
    DB.exec("UPDATE albums SET year = '#{@year}' WHERE id = #{@id};")
    DB.exec("UPDATE albums SET price = '#{@price}' WHERE id = #{@id};")
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

  def self.sort(sort_by)
    order = ""
    if sort_by == "name"
      order = "ASC"
    end
    if sort_by == "year"
      order = "DESC"
    end
    if sort_by == "price"
      order = "ASC"
    end
    returned_albums = DB.exec("SELECT * FROM albums ORDER BY #{sort_by} #{order};")
    albums = []
    returned_albums.each() do |album|
      id = album.fetch("id").to_i
      name = album.fetch("name")
      price = album.fetch("price")
      year = album.fetch("year")
      albums.push(Album.new({name: name, year: year, price: price, id: id}))
    end
    albums
  end

  def songs
    Song.find_by_album(self.id)
  end

  def get_random
    ids = DB.exec("SELECT id FROM albums;")
    random = rand(ids.length)
    random_id = ids[random]
    random_id
  end

  
end