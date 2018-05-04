
# SF DAHLIA SalesForce #

## INTRO ##
DAHLIA is the affordable housing portal for the City and County of San Francisco. It was created by the Mayor's Office of Housing and Community Development (MOHCD). This application streamlines the process of searching and applying for affordable housing, making it easier to rent, buy and stay in our City.

DAHLIA is constructed using SalesForce. The SalesForce application is used by several audiences. MOHCD uses it internally to manage housing programs and to run electronic lotteries. Public leasing agents submit new listings. Developers at large use the API to get access to public data. 

DAHLIA also has a web application that is use by the public and housing counselors to view affordable housing listings and to apply for  various housing lotteries. All data for the web application is stored in SalesForce. Repo for DAHLIA web application: https://github.com/Exygy/sf-dahlia-web-production.

## BUILD/Deploy ##
The assets are under the /src/classes folder

The build.properties and build.xml is for deployment via SFDC Migration toolkit. (Ant)

If you want to deploy this to your org, simply put your SFDC credentials including token and run the ant/deploy

## Overview ##

This is the codebase which supports the dahlia project. As a brief overview on how we put the classes together
there are 2 main types of classes.  

Types of Classes:
1. Service Level classes
2. Endpoint rest Service Classes


###Endpoint classes ###
Salesforce ties a specific URL pattern to a specific class.  We created classes for all these "endpoints".  The endpoint classes are responsible exposing the url and handling the url parameters for the call.  They are also responsible for building the request into the service layer.

All these classes are named as following.

<prefix>_<API Grouping><Post/Get><Name>
Api_ShortForm_GetContactByID - is an example - 

In the Listing entries - 
Listing is the prefix
Listing+<Group>+Api was how we named our endpoint classes.  In the future we may rename the Listing api, but for now it is what it is.

### Service layer classes ###

Service layer classes are as they sound, providing a service.  All operations surrounding a specific aspect such as "listing" are named as "service" classes.  They perform dml operations.  Some of them, such as the short form takes a specific View Model as a parameter.  They are in this application exposed for the endpoint classes but they could be exposed for controllers or any other apex class.



## Workspace setup ##

The project is setup to work either strictly with ant or with an IDE.  It assumes the following:

1. you have accessDahlia environment.  
2. you have git installed www.github.com
3. You've installed the sfdc migration toolkit + ant.  This is the ant plugin for salesforce and used to move metadata and code between SFDC orgs.

Steps for workspace setup

Checkout the project with git. 

1. at this point the following should take place
2. you should see a src folder and under it will be the metadata including your package.xml
3. Under a seprate folder called swagger will be the documentation for this project.

Using Ant for deploy

2. rename build.sample.properties build.properties and fill in your credentials
3. run the ant command - ant retrieveCode.
4. At this point you should have the latest code base from the org you're connected to.  It should be similar or the same as what you checked out.
5. From here you can optionally checkout your IDE into the same folder Structure as this project.  (Due to my issues with Eclipse and other IDES, I prefer to build in a folder separate from the repo and just use ant to keep the repo in sync)
6. Make changes to files and push them via the command "ant deployCode"
7. Happy Hacking

### Using swagger ###

1. Under the "Swagger" folder
2. To see the rest documentation open up the following url
3. http://editor.swagger.io/ 
4. load the swagger.json files included to see the appropriate api.
5. These files are publically hosted on heroku at 
	https://stark-inlet-37064.herokuapp.com
	https://git.heroku.com/stark-inlet-37064.git

### Testing the api ###
In order to test the api.  We recommend using the rest explorer

You can use any rest exploration tool including salesforces:

1. https://workbench.developerforce.com/restExplorer.php 
2. apigee or any other salesforce compatible rest explorer https://enterprise.apigee.com/platform/lukelim/

## License ##

Copyright (C) 2015 City and County of San Francisco

DAHLIA is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with DAHLIA. If not, see http://choosealicense.com/licenses/gpl-2.0/
