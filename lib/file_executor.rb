#!/usr/bin/ruby

require 'mysql2'

begin

client = Mysql2::Client.new(:host => "localhost", :username => "charlene", :password => 'ecsdigital', :database => 'mydb')
    client.query("CREATE TABLE IF NOT EXISTS \
        VersionTable(Id INT PRIMARY KEY AUTO_INCREMENT, Version VARCHAR(25))")
    client.query("INSERT IGNORE INTO VersionTable(Version) VALUES('1.createtable.sql ')")

rescue Mysql2::Error => e
    puts e.errno
    puts e.error

ensure
    client.close if client
end


class File_executor
  def all_files
     puts files_array = Dir['../scripts/*.sql'].each {|file| file}
  end

end



file_executor = File_executor.new
file_executor.all_files
