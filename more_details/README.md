# App overview
Topics addressed on this readme: 
- [Error handling](#tratamento)
- [Cache](#cache)
- [Architecture and classes’ structure](#arquitetura)
- [Screenshots](#prints)


<a name="tratamento"></a>
## Error handling

The app handles the following errors::
- Connectivity related exceptions are reported back to the user with the message 'No internet connection'
- Other types of exceptions are reported with the message 'We are having some difficulties, please try again later'
- Null fields and empty strings returned by the API are omitted from the final screens
- Posters that fail to load are replaced with a placeholder image

<a name="cache"></a>
## Cache

Initially, the app caches only the necessary data to display the ‘preview’ cards. More details about each film are downloaded and cached as the user accesses each film’s ‘details’ screen

<a name="arquitetura"></a>
## Architecture and classes’ structure

The chosen architecture was MVC. As such, the classes were divided into three categories:

### Views
Includes all ‘widget’ classes. They are tasked with requesting and displaying data from the controller, and manage the loading and error screens when necessary
- Classes: homeScreen; detailsScreen; movieCard; loadingScreen; failedToLoadScreen; filterMenu

### Controller
Tasked with bridging the gap between ‘view’ classes and ‘model’ classes. Request to the ‘model’ classes any information required by the ‘view’ classes, and pre-processes the returned raw data so that ‘view’ classes can simply read and display the information. The controller is also tasked with filtering the shown movies according to the genres selected by the user.
- Classes: Controller

### Models
Represent the data. The ‘movie’ class represents one movie and containd properties that will store the movie data. The ‘movieCatalog’ class is tasked with managing the cached movies. The ‘dataFetcher’ class handles the communication with the API.

<a name="prints"></a>
## Screenshots

<table style="border-color: white">
 <tr>
    <td><b style="font-size:20px">Home screen</b></td>
    <td style="padding-left: 5em"><b style="font-size:20px">Filter selection menu</b></td>
 </tr>
 <tr>
    <td><img src="homeScreen.jpg" width="200"/></td>
    <td style="padding-left: 5em"><img src="filterMenu.jpg" width="200"/></td>
 </tr>
 <tr style="padding-bottom: 5em">
    <td style="padding-bottom: 5em">Show a preview of each movie</td>
    <td style="padding-left: 5em; padding-bottom: 5em">Used by the user to select which genres the shown movies must have</td>
 </tr>
 </tr>
 <!-- 2nd row -->
 <tr>
    <td><b style="font-size:20px">Home screen with filtered movies</b></td>
    <td style="padding-left: 5em"><b style="font-size:20px">Details screen</b></td>
 </tr>
 <tr>
    <td><img src="filteredHomeScreen.jpg" width="200"/></td>
    <td style="padding-left: 5em"><img src="detailsScreen.jpg" width="200"/></td>
 </tr>
 <tr>
    <td style="padding-bottom: 5em">Home screen after filtering movies via the filter menu</td>
    <td style="padding-left: 5em; padding-bottom: 5em">Shows detailed information about the selected movie</td>
 </tr>
 <!-- 3rd row -->
 <tr>
    <td><b style="font-size:20px; padding-top: 5em">Loading screen</b></td>
    <td style="padding-left: 5em"><b style="font-size:20px">Error screen</b></td>
 </tr>
 <tr>
    <td><img src="loadingScreen.jpg" width="200"/></td>
    <td style="padding-left: 5em"><img src="errorScreen.jpg" width="200"/></td>
 </tr>
 <tr>
    <td>Shown while information is downloaded</td>
    <td style="padding-left: 5em">Shown in the eventuality of an error</td>
 </tr>
</table>

