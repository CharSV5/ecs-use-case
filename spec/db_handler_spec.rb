require 'db_handler'
describe DbHandler do
  db_handler = DbHandler.new('scripts', 'charlene', 'localhost',
                                   'mydb', 'ecsdigital')
  db_handler.clear_tables
  db_handler.create_table
  describe '.latest_version' do
    it 'returns the an empty string if no latest version of the database' do
      expect(db_handler.latest_version.empty?).to eq true
    end
    it 'returns the latest version in the database if there is one' do
      db_handler.execute_sql
      db_handler.update
      expect(db_handler.latest_version).to eq '11update.sql'
    end
  end
end
