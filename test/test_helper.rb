# frozen_string_literal: true

require "activerecord_lazy_columns"
require "minitest/autorun"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Base.logger = nil
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
    t.string :bio
  end
end

class User < ActiveRecord::Base
  lazy_columns :bio
end

User.create!(name: "Dima", bio: "Very long text")
