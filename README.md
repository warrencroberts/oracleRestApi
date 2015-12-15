# oracleRestApi
Repository for a rest api coding project given to me by Oracle

This project was implemented with Ruby 2.2.1 and Rails 4.2.5

The rails platform has very good support for implementing restful web services which is why I selected it.  By default rails runs on port 3000 although that can be changed on the command line.  It also uses an sqlite3 database that is located in oracleRestApi/events/db/development.sqlite3.

To run it you need to install the required ruby and rails versions via rvm.  To run the code you first need to start up the rails server.  Here are the steps :

  1.) cd to the oracleRestApi/events directory
  2.) rails server --port 8999

  After the rails server has started successfully you should be able to execute curl commands against it.  Note that I included the results of my test run in oracleRestApi/test_run_results.txt

  Let me know if you have any trouble getting it running.

  Warren
