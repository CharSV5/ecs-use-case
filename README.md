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
I was given a short deadline to implement a solution to this as best as possible. I found I had to make some decisions I wouldn't noramlly to meet the deadline. For instance, I usually follow the Red, Green, Refactor cycle closely, but I found that if I could implement a feature and test it manually in IRB, I had to move on even if the test was failing. I chose to leave the failing tests in as the act as specifications for what I was trying to achieve and provide greater clarity. Most of the requirements are met, however, I couldn't seem to get the update method to work so it would update the version table once execcuting the appropriate sql files. I was looking for a way with a placeholder to avoid string interpolation as that would make it vulnerable to SQL injections, but I ran out of time to implement this feature. Also, each time you run the program, it adds the dummy data (1.createtable) multiple times to the Version column in VersionTable as I am yet to find an effecive way of only adding it if it doesn't exist, like I did with the tables. If I had more time, I would have also added more tests. I also didn't utilise the folder object that is required as an argument from the ARGV array, but have used all other arguments.

## How to run
Run the file with arguments from the lib folder:
```ruby file_executor.rb scripts charlene localhost mydb ecsdigital ```
At the bottom of file_executor.rb, I have called all the methods needed to be called to replicate the actions of the user. To test yourself, comment out the calls at the bottom. I have included some dummy data so I could see what was happening, the program creates a row in the versions table, there are two dummy files 1.createtable.sql and 2.createtable.sql. The program should recognise that 1.createtable.sql already exists and not execute that one, you will see this by the absence of a PeopleTable in the database. If executed correctly, you will have a VersionTable and a UserTable that was created by the execution of 2.createtable.sql. This should also work for files named without the dot. You will have to check the database manually to see if the tables have been created. The VersionTable contains a column for current version.
