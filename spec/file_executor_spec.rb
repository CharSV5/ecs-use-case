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


end
