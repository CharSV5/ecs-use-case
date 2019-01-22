#!/usr/bin/ruby

require 'mysql2'

class UpdateDatabase
  def all_files
    Dir.glob("scripts/*.sql")
  end
end
