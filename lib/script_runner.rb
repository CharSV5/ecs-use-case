#!/usr/bin/ruby

require_relative 'update_database'
require_relative 'db_handler'

class ScriptRunner
  def verify_args
    if ARGV.length != 5
      puts 'Incorrect number of arguments, goodbye!'
      exit
    end
  end

  def db_handler
    DbHandler.new
  end

  def run_programme
    db_handler.create_table
    db_handler.update_database
    db_handler.update_database.all_files
    db_handler.latest_version
    db_handler.update_database.new_versions
    db_handler.update_database.new_versions_sorted
    db_handler.update_database.ordered_list
    db_handler.execute_sql
    db_handler.update
  end
end

scriptRunner = ScriptRunner.new
scriptRunner.verify_args
scriptRunner.run_programme
