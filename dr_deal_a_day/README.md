# Running the application
The application can be run by using any rack based server. For my development, I simply used the default WEBrick rails server, which can be started with ```rails s ``` on the command line and navigating to ```locahost:3000``` in a web browser.

# Interacting with the application
Before I describe how to interact with the application, I wanted to point out a few changes in my implementation from the original specifaction:
- Rather than saving the data files along with the data in the database, I instead decided to only save the data in the database and use an import/export model. I decided to do this because I thought storing the data both in the original file and the database was redundant, and it is also very easy to reproduce the files with an export if need be. Additionally, I think that relying more on the database will help the staff at DrDealADay learn the benefits of the database and rely on text files less altogether.
- I decided to show a table of all previous imports and their revenues, sorted by most recent, instead of only showing the revenue from the last uploaded file. I chose to do this because I thought it would be more useful for the user.
- The table of previous imports also allows the user to navigate to a different page that displays a table of all orders associated with that data file import. This page is intended to help identify imports and help avoid duplicate uploads.

## Imports page
The imports table lists all previous imports sorted in most recent order. The total revenue from all imports is listed at the bottom of the page.

To import a new data file, click the 'Upload a new data file' link and a form to do so will appear. A message will indicate if the import was successful. Otherwise, a descriptive error message will be displayed. Both csv and tsv formats are accepted.

The 'Data File' column in the imports table includes a link that will trigger an export and download of the import data in csv/tsv format. Each entry also inlcudes a 'View' link, which will navigate to the import summary page.

## Import summary page
The import summary page shows a table of all orders associated to the import that application is currently displaying. An export of the data in csv/tsv format can also be obtained on this page, by clicking on the 'Data File' link.

In the top right corner, there is a button that will delete the import that is being displayed. A confirmation message will appear before deletion takes place. All orders associated to the import will also be deleted.

## Errors that may be encountered
Below is a summary of errors that may be encountered when using the application. Whenever an error occurs, a message will be displayed at the top of the window.

###Error: no data file was selected.
This error occurs when the user presses the 'Upload' button on the new data file form, but no file was selected.

###Error: data file is incorrectly formatted.
This error occurs when the selected file has format errors within it, such as illegal quoting.

###Error: file contains invalid or missing data in row X
This error occurs when a row in the selected file does not satisfy valid data requirements. For example, if a row is missing a purchaser name, the row number will be reported for the user to inspect.

###Error: file contains no data.
This error occurs when the selected files has no rows of data in it.

###A previous import has the same file name...
This error occurs when a file is attempted to be imported but a previous import used a file of the same name. To avoid data duplication, the application requires that no two imports have the same filename. The error message will contain a link to the previous import with the same file name, where the user can compare the data to see if uploading the new file would result in duplication. If duplication would not occur, the user is instructed to change the file name and reupload it.


# Running tests
