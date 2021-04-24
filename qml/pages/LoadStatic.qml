/*Copyright (c) 2021, Riku Lahtinen
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import Sailfish.Silica 1.0
import "dbfunctions.js" as Mydbs
import QtQuick.LocalStorage 2.0
import QtQuick.XmlListModel 2.0
import io.thp.pyotherside 1.5

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Load static data")
            }

            Text {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                text: "Country Finland, City Jyväskylä. Load and extract the zip file https://tvv.fra1.digitaloceanspaces.com/209.zip to the folder /home/nemo/.local/share/harbour-catch-a-bus/fin/209" +
                      " Please wait until all the buttons are enabled."
            }

            Button {
                text:"1. Delete old data"
                onClicked: Mydbs.delete_tables()
            }

            Button {
                text:"2. Load new data"
                onClicked: spython.startDownload(StandardPaths.home + "/.local/share/harbour-catch-a-bus/" + country + "/" + citynumber + "/", "loaddata", "loaddata")
            }

            Button {
                text:"3. Unzip data"
                onClicked: spython.startDownload(StandardPaths.home + "/.local/share/harbour-catch-a-bus/" + country + "/" + citynumber + "/", "unzip", "unzip")
            }

            Button {
                text:"4. Create stops.xml"
                onClicked: spython.startDownload(StandardPaths.home + "/.local/share/harbour-catch-a-bus/" + country + "/" + citynumber + "/", "stops.txt", "stops.xml")
            }

            Button {
                text:"5. Create routes.xml"
                onClicked: spython.startDownload(StandardPaths.home + "/.local/share/harbour-catch-a-bus/" + country + "/" + citynumber + "/", "routes.txt", "routes.xml")
            }

            Button {
                text:"6. Create stop times.xml"
                onClicked: spython.startDownload(StandardPaths.home + "/.local/share/harbour-catch-a-bus/" + country + "/" + citynumber + "/", "stop_times.txt", "stop_times.xml")
            }

            Button {
                text:"7. Reload xml"
                enabled:busstops_xml.status == 1
                onClicked: {
                    busstops_xml.reload()
                    routes_xml.reload()
                    stoptimes_xml.reload()
                }
            }

            Button {
                text:"8. Load stops"
                enabled:busstops_xml.status == 1
                onClicked: Mydbs.load_stops()
            }

            Button {
                text:"9. Load routes"
                enabled: routes_xml.status == 1
                onClicked: Mydbs.load_routes()
            }

            Button {
                text:"10. Load stop times"
                enabled: stoptimes_xml.status == 1
                onClicked: Mydbs.load_stop_times()
            }




            XmlListModel {
                id: stoptimes_xml
                source: "../data/209/stop_times.xml"
                query: "/xml/stoptime"
                XmlRole {name:"day"; query:"day/string()"}
                XmlRole {name:"trip_id"; query:"trip_id/string()"}
                XmlRole {name:"start_time"; query:"start_time/string()"}
                XmlRole {name:"departure_time"; query:"departure_time/string()"}
                XmlRole {name:"stop_id"; query:"stop_id/string()"}
                XmlRole {name:"stop_sequence"; query:"stop_sequence/number()"}
            }

            XmlListModel {
                id: routes_xml
                source: StandardPaths.home + "/.local/share/harbour-catch-a-bus/" + country + "/" + citynumber + "/routes.xml" //Jyvaskyla
                //source: "../data/209/routes.xml"
                query: "/xml/routes"
                XmlRole {name:"route_id"; query:"route_id/string()"}
                XmlRole {name:"route_short_name"; query:"route_short_name/string()"}
                XmlRole {name:"route_long_name"; query:"route_long_name/string()"}
            }
        }
    }
    Python {
        id: spython
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));

            setHandler('message', function(msg1, msg2, msg3) {
                console.log(msg1, msg2, msg3);
            });
            importModule('staticfiles', function () {});
        }

        function startDownload(arg1, arg2, arg3){
            call('staticfiles.sloader.download', [arg1, arg2, arg3],function() {});

        }
    }
}
