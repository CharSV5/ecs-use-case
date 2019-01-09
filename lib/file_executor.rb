#!/usr/bin/ruby

require 'mysql2'

class File_executor

  def db_details
    details = ARGV
    if details.length < 4
      puts "Too few arguments"
      exit
    end
    #details[0] = directory with sql scripts
    #details[1] = username for the db
    #details[2] = db host
    #details[3] = db name
    #deatils[4] = db password
    details
  end

  def open_db
    Mysql2::Client.new(:host => db_details[2], :username => db_details[1], :password => db_details[4], :database => db_details[3])
  end

  def create_table
    client = open_db
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
    client = open_db
    latest = client.query("SELECT Version FROM VersionTable WHERE ID = (SELECT MAX(ID) FROM VersionTable)")
    version = ''
    latest.each { |row| version = row['Version'] }
    version
  end

  def all_files
    files_array = Dir['../scripts/*.sql'].each {|file| file}
    files_array
  end

  def new_versions
    version_num = latest_version.scan(/\d/).join('')
    new_version_array = []
    all_files.each do
      |version| num = version.scan(/\d/).join('')
      num > version_num ? new_version_array.push(version) : ''
    end
    new_version_array
    end

  def execute_sql
    client = open_db
    new_versions.each do
      |version| sql = File.open(version, 'rb') { |file| file.read }
      client.query(sql)
    end
  end

  def update
    client = open_db
    new_versions.each do
      |version|
      client.query("INSERT INTO VersionTable(Version) VALUES(?)", version)
    end
  end

end




file_executor = File_executor.new
file_executor.db_details
file_executor.create_table
file_executor.all_files
file_executor.latest_version
file_executor.new_versions
file_executor.execute_sql
