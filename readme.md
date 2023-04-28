# Weather data appication

### Test for yourself!
##### Frontend page
You can go to this website to visit the front end page of the application:
[```https://frontend-wczredvtgq-uc.a.run.app/```](https://frontend-wczredvtgq-uc.a.run.app/)
##### Backend, Database and Collector
Included with the project, there is a sampleSensors folder with a small node application, that will send every 2 minutes random data to the collector(which then every 10 minutes will submit to the backend, that will store on the database).



## What is the application?
This weather application can receive various data from weather sensors, store them, and show them to the user.

## Structure
There are 5 services involved in this application

##### Database
Holds the data for the application

##### Backend server
Serves as the database handler
Exposes two endpoints, one GET and one POST
The POST will receive weather data as a JSON string, and save it to the database
The GET will retrieve all the database data.

##### Frontend
This is a small Vue application that will render a table with all the data fetched from the backend server.
The data can be filtered by location.

##### Collector API
This application will gather data from various sensors, and submit it to the backend server.
There are various endpoits where weather sensors can submit their data(they should also include their location). The application will hold those values, and every 10 minutes submit one request for each location to the backend server.

##### External Collector
This application will fetch weather data from a real weather API for an array of locations, and submit those values to the backend server.
This application will run once per day.

### Deployment
The application is deployed on Google Cloud.
###### Database
Google Cloud SQL.
###### Backend
Google Cloud Run Service.
###### Frontend
Google Cloud Run Service.
###### Collector API
Google Cloud Run Service.
###### External Collector
Google Cloud Run Job, with an attached Google Cloud Scheduler (to run the application every day).


---
David Simões Batista, 2220658