require 'rspec'
require 'pg'
require 'album'
require 'song'
require 'pry'

# DB = PG.connect({ dbname: 'record_store_test', host: 'db', user: 'postgres', password: 'password' })
test_connection = PG.connect({ dbname: 'record_store_test', host: 'db', user: 'postgres', password: 'password' })

RSpec.configure do |config|
  config.after(:each) do
    # DB.exec("DELETE FROM albums *;")
    # DB.exec("DELETE FROM songs *;")
    test_connection.exec("DELETE FROM albums *;")
    test_connection.exec("DELETE FROM songs *;")
  end
end