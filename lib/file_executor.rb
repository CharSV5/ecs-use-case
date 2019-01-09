#!/usr/bin/ruby

require 'mysql2'

class File_executor
  def create_table
    client = Mysql2::Client.new(:host => 'localhost', :username => 'charlene', :password => 'ecsdigital', :database => 'mydb')
    client.query("CREATE TABLE IF NOT EXISTS \
    VersionTable(Id INT PRIMARY KEY AUTO_INCREMENT, Version VARCHAR(25))")
    client.query("INSERT IGNORE INTO VersionTable(Version) VALUES('1.createtable.sql')")
  rescue Mysql2::Error => e
    puts e.errno
    puts e.error
  ensure
    client.close if client
  end

  def latest_version
    client = Mysql2::Client.new(:host => 'localhost', :username => 'charlene', :password => 'ecsdigital', :database => 'mydb')
    latest = client.query("SELECT Version FROM VersionTable WHERE ID = (SELECT MAX(ID) FROM VersionTable)")
    version = ''
    latest.each { |row| version = row['Version'] }
    version
  end

  def all_files
    files_array = Dir['../scripts/*.sql'].each {|file| file}
    files_array
  end

  def update
    version_num = latest_version.scan(/\d/).join('')
    new_version_array = []
    all_files.each do
      |version| num = version.scan(/\d/).join('')
      num > version_num ? new_version_array.push(version) : ''
    end
    new_version_array
  end

end



file_executor = File_executor.new
file_executor.create_table
file_executor.all_files
file_executor.latest_version
file_executor.update
