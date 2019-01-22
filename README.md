# ECS Use Case

## What this program does
This program solves the problems laid out here:

·   A database upgrade requires the execution of numbered SQL scripts stored in a specified folder, named such as '045.createtable.sql'

        - The scripts may contain any simple SQL statement(s) to any table of your choice, e.g. 'INSERT INTO testTable VALUES("045.createtable.sql");'



·   There may be gaps in the SQL file name numbering and there isn't always a . (dot) after the beginning number



·   The database upgrade is based on looking up the current version in the database and comparing this number to the numbers in the script names

        - The table where the current db version is stored is called 'versionTable', with a single row for the version, called 'version'



·   If the version number from the db matches the highest number from the scripts then nothing is executed



·   All scripts that contain a number higher than the current db version will be executed against the database in numerical order



·   In addition, the database version table is updated after the script execution with the executed script's number



·   Your script will be executed automatically via a program, and must satisfy these command line input parameters exactly in order to run:

        - './your-script.your-lang directory-with-sql-scripts username-for-the-db db-host db-name db-password'

## How I built this
I started with one class and made sure the programme did what it is supposed to do, then I did a class extraction to abide by the single responsibility principle.

## How to run
Run the file with arguments from the lib folder:
```ruby script_runner.rb scripts charlene localhost mydb ecsdigital ```
At the bottom of script_runner.rb, I have called all the methods needed to be called to replicate the actions of the user. To test yourself, comment out the calls at the bottom. I have included some dummy data so I could see what was happening, the programme creates a row in the versions table, there are thre dummy files 1.createtable.sql and 11update.sql and 4.createtable.sql. The above command will execute all three sql files, if you try to run it again, you will see a message saying 'you are already up to date!' and the programme will stop running. If you check in mysql manually, you will see the creation of four tables, VersionTable, PeopleTable, UserTable and AddressTable. The last three are the result of the sql files in the scripts folder being executed in order.

You can also test this programme in irb. Load the path to the db_handler.rb file and create a new instance. Look at the run_programme method in script_runner.rb for an idea of what commands to run and in which order.
