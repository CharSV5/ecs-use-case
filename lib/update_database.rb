#!/usr/bin/ruby

require 'mysql2'

class UpdateDatabase
  def initialize(latest_version)
    @latest_version = latest_version
  end

  def all_files
    Dir.glob("scripts/*.sql")
  end

  def new_versions
    version_num = @latest_version.scan(/\d+/).join('')
    new_version_array = []
    all_files.each do
      |version| num = version.scan(/\d+/).join('')
      new_version_array.push(version) if num.to_i > version_num.to_i
    end
    if new_version_array.empty?
      puts 'You are already up to date!'
      exit
    end
    new_version_array
  end

  def new_versions_sorted
    new_versions.sort_by { |x| x[/\d+/].to_i }
  end

  def ordered_list
    ordered_array = new_versions.map do |version|
        version.split('/')[-1]
    end
    ordered_array.sort_by(&:to_i)
  end
end
