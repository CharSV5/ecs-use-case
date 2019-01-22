#!/usr/bin/ruby

require 'mysql2'
require_relative 'update_database'

class FileExecutor
  attr_reader :table_created
  def initialize(directory = ARGV[0], username = ARGV[1], host = ARGV[2], database = ARGV[3], password = ARGV[4])
    @details = []
    @details.push(directory, username, host, database, password)
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
    UpdateDatabase.new(latest_version)
  end

  def execute_sql
    client = open_db
    update_database.new_versions_sorted.each do |version|
      sql = File.open(version, 'rb') { |file| file.read }
      client.query(sql)
    end
    client.close if client
  end

  def update
    client = open_db
    update_database.ordered_list.each do |version|
      client.query("INSERT INTO VersionTable(Version) VALUES('#{version}')")
    end
    client.close if client
  end
end
