require 'file_executor'

describe File_executor do
  file_executor = File_executor.new
  describe '.all_files' do
    it 'returns all the sql files in an array' do
    expect(file_executor.all_files).to eq ['../scripts/2.createtable.sql',
      '../scripts/1.createtable.sql'
      ]
    end
  end
end
