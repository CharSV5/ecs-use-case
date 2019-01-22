#!/usr/bin/ruby

require 'mysql2'

class FileExecutor
  attr_reader :table_created
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
      client.close if client
  end

  def clear_tables
    # for test purposes
    client = open_db
    client.query("DROP TABLE IF EXISTS VersionTable, UserTable, AddressTable, PeopleTable")
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

  def update_database
    UpdateDatabase.new
  end

  def new_versions
    version_num = latest_version.scan(/\d+/).join('')
    new_version_array = []
    update_database.all_files.each do
      |version| num = version.scan(/\d+/).join('')
      puts "num = #{num}"
      puts "version = #{version_num}"
      new_version_array.push(version) if num.to_i > version_num.to_i
    end
    puts "new version array = #{new_version_array}"
    if new_version_array.empty?
      puts 'You are already up to date!'
      exit
    end
    new_version_array
    end

    def new_versions_sorted
      new_versions.sort_by { |x| x[/\d+/].to_i }
    end

  def execute_sql
    client = open_db
    new_versions_sorted.each do |version|
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

  def run_programme
    update_database.all_files
    latest_version
    new_versions
    new_versions_sorted
    execute_sql
    update
  end

end

# fileExecutor = FileExecutor.new
# fileExecutor.verify_args
# fileExecutor.create_table
# fileExecutor.run_programme
