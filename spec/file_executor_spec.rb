require 'file_executor'
describe FileExecutor do
  file_executor = FileExecutor.new("scripts", "charlene", "localhost", "mydb", "ecsdigital")
  describe '.all_files' do
    it 'returns all the sql files in an array' do
    expect(file_executor.all_files).to eq ["1.createtable.sql", "11update.sql", "4.createtable.sql"]
    end
    describe '.latest_version' do
      it 'returns the latest version of the database' do
        file_executor.create_table
        expect(file_executor.latest_version).to eq '1.createtable.sql'
      end
    end
  end
  describe '.new_versions' do
    it 'returns an array with the current version file names' do
      file_executor.create_table
      file_executor.all_files
      file_executor.latest_version
      expect(file_executor.new_versions).to eq ["11update.sql", "4.createtable.sql"]
    end
  end
  describe '.ordered_list' do
    it 'puts the files into order by integer' do
      file_executor.create_table
      file_executor.all_files
      file_executor.latest_version
      file_executor.new_versions
      expect(file_executor.ordered_list).to eq ['4.createtable.sql', '11update.sql']

    end
  end
end
