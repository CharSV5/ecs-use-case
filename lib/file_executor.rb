#!/usr/bin/ruby

require 'mysql2'

class FileExecutor
  attr_reader :files_array
  # initialize method is for test purposes so arguments don't have to be provided
  def initialize(directory = ARGV[0], username = ARGV[1], host = ARGV[2], database = ARGV[3], password = ARGV[4])
    @details = []
    @details.push(directory, username, host, database, password)
  end

  def verify_args
    if ARGV.length != 5
      puts 'Incorrect number of arguments, goodbye!'
      exit
    end
  end

  def open_db
    puts "details = #{@details}"
    Mysql2::Client.new(:host => @details[2], :username => @details[1],
      :password => @details[4], :database => @details[3])
  end

  def create_table
    client = open_db
    client.query("CREATE TABLE IF NOT EXISTS \
    VersionTable(Id INT PRIMARY KEY AUTO_INCREMENT, Version VARCHAR(35))")
    client.query("INSERT INTO VersionTable(Version) \
     VALUES('1.createtable.sql')")
     client.close if client
  end

  def latest_version
    client = open_db
    latest = client.query("SELECT Version FROM VersionTable \
      WHERE ID = (SELECT MAX(ID) FROM VersionTable)")
    version = ''
    latest.each { |row| version = row['Version'] }
    client.close if client
    version
  end

  def all_files
    Dir.glob("scripts/*.sql")  
  end

  def new_versions
    version_num = latest_version.scan(/\d/).join('')
    new_version_array = []
    all_files.each do
      |version| num = version.scan(/\d/).join('')
      new_version_array.push(version) if num > version_num
    end
    new_version_array
    end

  def execute_sql
    client = open_db
    new_versions.each do |version|
      sql = File.open(version, 'rb') { |file| file.read }
      client.query(sql)
    end
    client.close if client
  end

  def ordered_list
    ordered_array = new_versions.map do |version|
        version.split('/')[-1]
    end
    ordered_array.sort_by(&:to_i)
  end

  def update
    client = open_db
    ordered_list.each do |version|
      client.query("INSERT INTO VersionTable(Version) VALUES('#{version}')")
    end
    client.close if client
  end

end

# fileExecutor = FileExecutor.new
# fileExecutor.verify_args
# fileExecutor.create_table
# fileExecutor.all_files
# fileExecutor.latest_version
# fileExecutor.new_versions
# fileExecutor.execute_sql
# fileExecutor.update
