require 'file_executor'

describe File_executor do
  file_executor = File_executor.new
  describe '.all_files' do
    it 'returns all the sql files in an array' do
    expect(file_executor.all_files).to eq ['../scripts/2.createtable.sql',
      '../scripts/1.createtable.sql'
      ]
    end
    describe '.latest_version' do
      it 'returns the latest version of the database' do
        file_executor.create_table
        expect(file_executor.latest_version).to eq '1.createtable.sql'
      end
    end
  end
  describe '.update' do
    it 'returns an array with the current version file names' do
      file_executor.create_table
      file_executor.all_files
      file_executor.latest_version
      expect(file_executor.update).to eq ["../scripts/2.createtable.sql"]
    end
  end
end
