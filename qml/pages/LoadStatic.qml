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
    property string load_citynumber: "xxx"
    property string load_country: "xxx"
    property string load_path: StandardPaths.home + "/.local/share/harbour-catch-a-bus/"

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
                text: "On this page data loading is done to the folder /home/nemo/.local/share/harbour-catch-a-bus/" +
                      " Please wait until all the buttons are enabled."
            }

            ComboBox {
                id: selCountry
                width: parent.width
                label: qsTr("Country")
                menu: ContextMenu {
                    MenuItem {
                        //: Country name
                        text: qsTr("Select")
                        onClicked: {
                            load_country = "xxx"
                        }
                    }
                    MenuItem {
                        text: qsTr("Finland")
                        onClicked: {
                            load_country = "fin"
                        }
                    }
                }
            }

            ComboBox {
                id: selCity
                width: parent.width
                label: qsTr("Country")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Select")
                        onClicked: {
                            load_citynumber = "xxx"
                        }
                    }
                    MenuItem {
                        text: qsTr("Joensuu")
                        onClicked: {
                            load_citynumber = "207"
                        }
                    }
                    MenuItem {
                        text: qsTr("Jyväskylä")
                        onClicked: {
                            load_citynumber = "209"
                        }
                    }
                    MenuItem {
                        text: qsTr("Lahti")
                        onClicked: {
                            load_citynumber = "223"
                        }
                    }
                }
            }
            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0
                text:"1. Delete old data"
                onClicked: Mydbs.delete_tables()
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0
                text:"2. Load new data"
                onClicked: spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "loaddata", "loaddata", load_country, load_citynumber)
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0
                text:"3. Unzip data"
                onClicked: spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "unzip", "unzip", load_country, load_citynumber)
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0
                text:"4. Create stops.xml"
                onClicked: spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "stops.txt", "stops.xml", load_country, load_citynumber)
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0
                text:"5. Create routes.xml"
                onClicked: spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "routes.txt", "routes.xml", load_country, load_citynumber)
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0
                text:"6. Create stop_times.xml"
                onClicked: spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "stop_times.txt", "stop_times.xml", load_country, load_citynumber)
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0
                text:"7. Create trips.xml"
                onClicked: spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "trips.txt", "trips.xml", load_country, load_citynumber)
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0 && busstops_xml.status == 1
                text:"7. Reload xml"
                onClicked: {
                    busstops_xml.reload()
                    routes_xml.reload()
                    stoptimes_xml.reload()
                }
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0 && busstops_xml.status == 1
                text:"8. Load stops"
                onClicked: Mydbs.load_stops()
            }

            Button {
                enabled:selCountry.currentIndex > 0 && selCity.currentIndex > 0 && routes_xml.status == 1
                text:"9. Load routes"
                onClicked: Mydbs.load_routes()
            }

            Button {
                enabled: selCountry.currentIndex > 0 && selCity.currentIndex > 0 && stoptimes_xml.status == 1
                text:"10. Load stop times"
                onClicked: Mydbs.load_stop_times()
            }

            Button {
                enabled: selCountry.currentIndex > 0 && selCity.currentIndex > 0 && stoptimes_xml.status == 1
                text:"11. Load trips"
                onClicked: Mydbs.load_trips()
            }

            XmlListModel {
                id: stoptimes_xml
                source: load_path + load_country + "/" + load_citynumber + "/stop_times.xml"
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
                source: load_path + load_country + "/" + load_citynumber + "/routes.xml"
                query: "/xml/routes"
                XmlRole {name:"route_id"; query:"route_id/string()"}
                XmlRole {name:"route_short_name"; query:"route_short_name/string()"}
                XmlRole {name:"route_long_name"; query:"route_long_name/string()"}
            }

            XmlListModel {
                id: trips_xml
                source: load_path + load_country + "/" + load_citynumber + "/trips.xml"
                query: "/xml/trips"
                XmlRole {name:"route_id"; query:"route_id/string()"}
                XmlRole {name:"service_id"; query:"service_id/string()"}
                XmlRole {name:"trip_id"; query:"trip_id/string()"}
            }
        }
    }

    Python {
        id: spython
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));

            setHandler('message', function(msg1, msg2, msg3, msg4, msg5) {
                console.log(msg1, msg2, msg3, msg4, msg5);
            });
            importModule('staticfiles', function () {});
        }

        function startDownload(arg1, arg2, arg3, arg4, arg5) {
            call('staticfiles.sloader.download', [arg1, arg2, arg3, arg4, arg5],function() {});

        }
    }
}
