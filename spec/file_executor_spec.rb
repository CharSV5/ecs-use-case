require 'file_executor'
describe FileExecutor do
  file_executor = FileExecutor.new("scripts", "charlene", "localhost", "mydb", "ecsdigital")
  file_executor.clear_tables
    describe '.latest_version' do
      it 'returns the an empty string if no latest version of the database' do
        file_executor.create_table
        expect(file_executor.latest_version.empty?).to eq true
      end
      it 'returns the latest version in the database if there is one' do
        file_executor.create_table
        file_executor.execute_sql
        file_executor.update
        expect(file_executor.latest_version).to eq '11update.sql'
      end
    end

  describe '.new_versions' do
    it 'returns an array with the current version file names' do
      file_executor.create_table
      update_database = UpdateDatabase.new
      update_database.all_files
      file_executor.latest_version
      expect(file_executor.new_versions).to eq ["scripts/1.createtable.sql", "scripts/11update.sql", "scripts/4.createtable.sql"]
    end
  end
  describe '.ordered_list' do
    it 'puts the files into a readable format for the database' do
      file_executor.create_table
      update_database = UpdateDatabase.new
      update_database.all_files
      file_executor.latest_version
      file_executor.new_versions
      expect(file_executor.ordered_list).to eq ["1.createtable.sql", "4.createtable.sql", "11update.sql"]
    end
  end
  describe '.new_versions_sorted' do
    it 'sorts the versions for correct execution' do
      file_executor.create_table
      update_database = UpdateDatabase.new
      update_database.all_files
      file_executor.latest_version
      file_executor.new_versions
      expect(file_executor.new_versions_sorted).to eq ["scripts/1.createtable.sql", "scripts/4.createtable.sql", "scripts/11update.sql"]
    end
  end
end
