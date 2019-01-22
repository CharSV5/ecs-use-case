require 'update_database'
require 'file_executor'
describe UpdateDatabase do
  file_executor = FileExecutor.new("scripts", "charlene", "localhost", "mydb", "ecsdigital")
  file_executor.clear_tables
  file_executor.create_table
  update_database = UpdateDatabase.new(file_executor.latest_version)
  describe '.all_files' do
    it 'returns all the sql files in an array' do
    expect(update_database.all_files).to eq ["scripts/1.createtable.sql", "scripts/11update.sql", "scripts/4.createtable.sql"]
    end
  end
  describe '.new_versions' do
    it 'returns an array with the current version file names' do
      update_database.all_files
      file_executor.latest_version
      expect(update_database.new_versions).to eq ["scripts/1.createtable.sql", "scripts/11update.sql", "scripts/4.createtable.sql"]
    end
  end
  describe '.ordered_list' do
    it 'puts the files into a readable format for the database' do
      update_database.all_files
      file_executor.latest_version
      update_database.new_versions
      expect(update_database.ordered_list).to eq ["1.createtable.sql", "4.createtable.sql", "11update.sql"]
    end
  end
  describe '.new_versions_sorted' do
    it 'sorts the versions for correct execution' do
      update_database.all_files
      file_executor.latest_version
      update_database.new_versions
      expect(update_database.new_versions_sorted).to eq ["scripts/1.createtable.sql", "scripts/4.createtable.sql", "scripts/11update.sql"]
    end
  end
end
