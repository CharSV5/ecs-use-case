require 'update_database'
describe UpdateDatabase do
  update_database = UpdateDatabase.new
  describe '.all_files' do
    it 'returns all the sql files in an array' do
    expect(update_database.all_files).to eq ["scripts/1.createtable.sql", "scripts/11update.sql", "scripts/4.createtable.sql"]
    end
  end
end
