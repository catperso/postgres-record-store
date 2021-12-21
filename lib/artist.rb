class Artist

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


end