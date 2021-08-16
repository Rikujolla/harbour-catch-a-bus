# Catch a bus
harbour-catch-a-bus
## SUMMARY
An app to help to catch a bus in time
## PRIVACY
As a maintainer of this code I do not collect any information of you. The app is not sending any information of your identity to me. I might get some general information of the app users depending on the store you installed the app.
## KNOWN ISSUES
- To add a new city is not easy yet.
- The app is still on it's prototype level
## INSTALLATION PREPARATION
1. Install required python elements using terminal application on your phone as follows:
devel-su
pkcon install python3-pip
pip install --upgrade gtfs-realtime-bindings
2. Load city static data and manipulate it to xml resulting the files. I try to automate this.
## USING THE APP
1. Select first settings on the first page. Select a country and the city. Then load the static data pressing buttons in sequence. Unfortunately that is not very automatic:(. If the data amount is huge, selecting only stops needed is important not to fill the phone.
2. The easiest way to use the app is to select the stop first. Then select the bus on that stop. Then start tracking.
3. New cities can be added to the file /usr/share/harbour-catch-a-bus/qml/data/city.xml. If you send me the data via github comment or pull request it can be included in next version.
