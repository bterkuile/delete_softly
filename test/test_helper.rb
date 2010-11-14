require 'rubygems'
require 'test/unit'
require 'arel'
require 'active_support'
require 'active_support/all'
require 'lib/delete_softly'
require 'sqlite3'


ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'test/db.sqlite3'
)

class Post < ActiveRecord::Base
  delete_softly
  has_many :comments
end

class Comment < ActiveRecord::Base
  delete_softly false
  belongs_to :post
  has_many :tags
end

class Tag < ActiveRecord::Base
  belongs_to :comment
end

unless Post.table_exists?
  puts  "Creating  table posts"
  ActiveRecord::Base.connection.create_table "posts" do |t|
    t.string :title
    t.text :body
    t.datetime :deleted_at
    t.timestamps
  end
end
unless Comment.table_exists?
  puts  "Creating  table comments"
  ActiveRecord::Base.connection.create_table "comments" do |t|
    t.string :email
    t.text :body
    t.integer :post_id
    t.datetime :deleted_at
    t.timestamps
  end
end
unless Tag.table_exists?
  puts  "Creating  table tags"
  ActiveRecord::Base.connection.create_table "tags" do |t|
    t.string :name
    t.integer :comment_id
    t.timestamps
  end
end
