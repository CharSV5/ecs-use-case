
class File_executor
  def all_files
     puts files_array = Dir['../scripts/*.sql'].each {|file| file}
  end

end



file_executor = File_executor.new
file_executor.all_files
