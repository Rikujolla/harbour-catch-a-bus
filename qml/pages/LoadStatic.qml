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
    property bool downloading: false
    property int level: 0
    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Load static data")
                description: selections.get(0).country_name + ", " + selections.get(0).city
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
                text: qsTr("As default the data loading is done to the folder /home/nemo/.local/share/harbour-catch-a-bus/") + "\n" +
                      qsTr("I recommend to change the default path to the folder on your sdcard not to fill your phone with temporary files.") +"\n"+
                      qsTr("After the path selection, please press all the buttons in sequence! Some phases may take up to a minute and the phone may become unresponsive for a while.")
            }

            TextField {
                id: path_selection
                placeholderText: qsTr("Enter path")
                anchors.horizontalCenter: parent.horizontalCenter
                //validator: RegExpValidator { regExp: /^[0-9]{0,}$/ }
                //color: errorHighlight? "red" : Theme.primaryColor
                //inputMethodHints:  Qt.ImhDigitsOnly
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    focus = false;
                    if(text != "") {load_path = text}
                    selections.set(0,{"localpath": text})
                    Mydbs.saveSettings()
                }
            }



            Button {
                id:button1
                enabled:level == 0 && page.downloading == false
                text:"1. " + qsTr("Load new data")
                onClicked: {
                    spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "loaddata", "loaddata", load_country, load_citynumber, selections.get(0).staticpath)
                    page.downloading = true
                }
            }

            Button {
                id:button2
                enabled:level == 1 && page.downloading == false
                text:"2. " + qsTr("Unzip data")
                onClicked: {
                    spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "unzip", "unzip", load_country, load_citynumber, selections.get(0).staticpath)
                    page.downloading = true
                }
            }

            Button {
                id:button3
                enabled:level == 2 && page.downloading == false
                text:"3. " + qsTr("Create xml files")
                onClicked: {
                    spython.startDownload(load_path + load_country + "/" + load_citynumber + "/", "calendar.txt", "calendar.xml", load_country, load_citynumber, selections.get(0).staticpath)
                    page.downloading = true
                }
            }

            Button {
                id:button4
                enabled:level == 3 && page.downloading == false
                text:"4. " + qsTr("Reload xml")
                onClicked: {
                    calendar_xml.reload()
                    calendar_dates_xml.reload()
                    routes_xml.reload()
                    busstops_xml.reload()
                    trips_xml.reload()
                    stoptimes_xml.reload()
                    page.level = 4
                }
            }

            Button {
                id:button5
                enabled: page.level == 4 && stoptimes_xml.status == 1
                text:"5. " + qsTr("Load data to database")
                onClicked: {
                    Mydbs.delete_tables()
                    Mydbs.load_calendar()
                    Mydbs.load_calendar_dates()
                    Mydbs.load_stops()
                    Mydbs.load_routes()
                    Mydbs.load_trips()
                    Mydbs.load_stop_times()
                    page.level = 5
                }
            }

            XmlListModel {
                id: calendar_xml
                source: load_path + load_country + "/" + load_citynumber + "/calendar.xml"
                query: "/xml/calendar"
                XmlRole {name:"service_id"; query:"service_id/string()"}
                XmlRole {name:"monday"; query:"monday/string()"}
                XmlRole {name:"tuesday"; query:"tuesday/string()"}
                XmlRole {name:"wednesday"; query:"wednesday/string()"}
                XmlRole {name:"thursday"; query:"thursday/string()"}
                XmlRole {name:"friday"; query:"friday/string()"}
                XmlRole {name:"saturday"; query:"saturday/string()"}
                XmlRole {name:"sunday"; query:"sunday/string()"}
                XmlRole {name:"start_date"; query:"start_date/string()"}
                XmlRole {name:"end_date"; query:"end_date/string()"}
            }

            XmlListModel {
                id: calendar_dates_xml
                source: load_path + load_country + "/" + load_citynumber + "/calendar_dates.xml"
                query: "/xml/calendar_dates"
                XmlRole {name:"service_id"; query:"service_id/string()"}
                XmlRole {name:"date"; query:"date/string()"}
                XmlRole {name:"exception_type"; query:"exception_type/string()"}
            }

            XmlListModel {
                id: busstops_xml
                source: load_path + load_country + "/" + load_citynumber + "/stops.xml"
                query: "/xml/stop"
                XmlRole {name:"stop_id"; query:"stop_id/string()"}
                XmlRole {name:"stop_name"; query:"stop_name/string()"}
                XmlRole {name:"stop_lat"; query:"stop_lat/number()"}
                XmlRole {name:"stop_lon"; query:"stop_lon/number()"}
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

    Component.onCompleted: {
        Mydbs.loadSettings()
        load_country = selections.get(0).country
        load_citynumber = selections.get(0).citynumber
        if(selections.get(0).localpath != "") { path_selection.text = load_path = selections.get(0).localpath}
        console.log(load_path, load_country, load_citynumber)
    }

    Python {
        id: spython
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));

            setHandler('message', function(msg1, msg2, msg3, msg4, msg5) {
                console.log(msg1, msg2, msg3, msg4, msg5);
            });
            setHandler('finished', function(newvalue) {
                page.downloading = false;
                page.level = page.level + 1;
                //console.log( "finished" , newvalue);
            });
            importModule('staticfiles', function () {});
        }

        function startDownload(arg1, arg2, arg3, arg4, arg5, arg6) {
            call('staticfiles.sloader.download', [arg1, arg2, arg3, arg4, arg5, arg6],function() {});

        }
    }
}
