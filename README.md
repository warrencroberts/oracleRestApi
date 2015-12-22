# oracleRestApi
Repository for a rest api coding project given to me by Oracle

This project was implemented with Ruby 2.2.1 and Rails 4.2.5

The rails platform has very good support for implementing restful web services which is why I selected it.  By default rails runs on port 3000 although that can be changed on the command line.  It also uses an sqlite3 database that is located in oracleRestApi/events/db/development.sqlite3.

To run it you need to install the required ruby and rails versions via rvm.  To run the code you first need to start up the rails server.  Here are the steps :

  1.) cd to the oracleRestApi/events directory
  2.) rails server --port 8999

  After the rails server has started successfully you should be able to execute curl commands against it.

  The api supports the following calls
  	---------------------------------------------------------------------
 	curl -v -X DELETE http://localhost:3000/events
  	HTTP/1.1 205 Reset Content

  	If there is content in the repository it will all be deleted.  If the repository is empty no action is taken
  	---------------------------------------------------------------------
	curl -v -X DELETE http://localhost:3000/events/22
	HTTP/1.1 205 Reset Content
	{"id":22}

	This call will remove the event with id 22 from the reprository if it exists.  The return value is the id of the event that was deleted.

	HTTP/1.1 204 No Content

	If the repository doesn't contain a recored corresponding to the id, status 204 will be returned.
 	---------------------------------------------------------------------
	curl -v -X POST "http://localhost:3000/events" -H "Content-Type: application/json" -d '{"data":"NAME is now at LATITUDE/LONGITUDE"}'
	HTTP/1.1 201 Created
	{"event":{"id":22,"data":"NAME is now at LATITUDE/LONGITUDE"}}

	Post will add a new record to the repository.  It returns status 201 as well as the json object that was just created.

	curl -v -X POST "http://localhost:3000/events/5" -H "Content-Type: application/json" -d '{"data":"NAME is now at LATITUDE/LONGITUDE"}
	'HTTP/1.1 400 Bad Request
	
	If the request contains an id the repository will send back status 400.
 	---------------------------------------------------------------------
	curl -v -X GET http://localhost:3000/events
	HTTP/1.1 200 OK
	[{"event":{"id":21,"data":"NAME is now at LATITUDE/LONGITUDE"}},{"event":{"id":22,"data":"NAME_22_1 is now at LATITUDE/LONGITUDE"}}]

	A get request with no id specified will return status 200 and an array of all json objects currently in the repository.

 	HTTP/1.1 204 No Content

 	If the repository is empty status 204 will be returned.
	---------------------------------------------------------------------
	curl -v -X GET http://localhost:3000/events/21
	HTTP/1.1 200 OK
	{"event":{"id":21,"data":"NAME is now at LATITUDE/LONGITUDE"}}

	When a get request is sent with an id the interface will return status 200 and return the requested object.

	HTTP/1.1 204 No Content

	If the requested object doesn't exist in the repository status 204 will be returned.
	---------------------------------------------------------------------
	curl -v -X PUT "http://localhost:3000/events/22" -H "Content-Type: application/json" -d '{"data":"NAME-22-2 is now at LATITUDE/LONGITUDE"}'
	HTTP/1.1 202 Accepted
	{"event":{"id":22,"data":"NAME-22-2 is now at LATITUDE/LONGITUDE"}}

	To change an event in the repository you can send a put request with the id of the event you want to change.  The repository will respond with status 202 if the request was accepted and returns the json event object that was created.

	HTTP/1.1 204 No Content
	It the repository doesn't contain an object for this id status 204 is sent back.
	---------------------------------------------------------------------

To see the result of running all of these rest requests please see the oracleRestApi/test_run_results.txt file.
