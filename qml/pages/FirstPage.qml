/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import QtQuick.LocalStorage 2.0
import "functions.js" as Myfunc
import "dbfunctions.js" as Mydbs

Page {
    id: page
    onStatusChanged: {
        if (selections.get(0).stop_name == 'Not selected'){
            selected_stop.text = selections.get(0).stop_name
        }
        else {
            selected_stop.text = selections.get(0).stop_name + ", " + selections.get(0).dist_me + " m"
        }
        competition.text = "Me " + selections.get(0).dist_me + " m - The bus " + selections.get(0).dist_bus + " m"
        if (selections.get(0).trip_id == 'Not selected'){
            selected_bus.text = selections.get(0).trip_id
        }
        else {
            selected_bus.text = selections.get(0).route_short_name + " " + selections.get(0).start_time.substring(0,5) + " " + selections.get(0).label
        }
    }
    property bool downloading: false

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("About.qml"))
                }
            }
            MenuItem {
                text: qsTr("Load static data")
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("LoadStatic.qml"))
                }
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("Settings.qml"))
                }
            }
            MenuItem {
                text: qsTr("Select a bus")
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("Busses.qml"))
                }
            }
        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Catch a bus")
            }

            BackgroundItem {
                SectionHeader { text: qsTr("Selected bus stop") }
                onClicked: {
                    Mydbs.get_closest_stop()
                    pageStack.push(Qt.resolvedUrl("Stops.qml"))
                }
            }

            BackgroundItem {
                Label {
                    id:selected_stop
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Theme.paddingLarge
                    }
                    text: ""
                }
                onClicked: {
                    if (selected_stop.text == "Not selected"){
                        Mydbs.get_closest_stop()
                        pageStack.push(Qt.resolvedUrl("Stops.qml"))
                    }
                    else {
                        pageStack.push(Qt.resolvedUrl("StopSchedule.qml"))
                    }
                }
            }

            BackgroundItem {
                SectionHeader { text: qsTr("Selected bus connection") }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Busses.qml"))
                }
            }

            TextField {
                id: bus
                placeholderText: "Enter bus line"
                anchors.horizontalCenter: parent.horizontalCenter
                validator: RegExpValidator { regExp: /^[0-9]{0,}$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                inputMethodHints:  Qt.ImhDigitsOnly
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    focus = false;
                }
            }

            BackgroundItem {
                Label {
                    id:selected_bus
                    font.pixelSize:Theme.fontSizeLarge
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Theme.paddingLarge
                    }
                    text: ""
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("StopSchedule.qml"))
                }
            }

            BackgroundItem {
                Label {
                    id: positsione
                    text: ""
                    font.pixelSize:Theme.fontSizeLarge
                    visible: !page.downloading
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                onClicked: {
                    Mydbs.fill_sequence(day,selections.get(0).trip_id,selections.get(0).start_time)
                    //console.log(day,selections.get(0).trip_id,selections.get(0).start_time)
                    pageStack.push(Qt.resolvedUrl("StopSeq.qml"))
                }
            }

            ProgressBar {
                id: dlprogress
                label: "Downloading bus data."
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                visible: page.downloading
            }

            SectionHeader { text: qsTr("Me to bus competition") }

            BackgroundItem {
                Label {
                    id:competition
                    font.pixelSize:Theme.fontSizeLarge
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Theme.paddingLarge
                    }
                    text: ""
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("StopSchedule.qml"))
                }
            }
        }

        Button {
            id:trackbutton
            text: "Start tracking"
            enabled: !page.downloading
            anchors.bottom: bottombutton.top
            width: parent.width
            onClicked: {
                distanceLoader.start()
            }
        }

        Timer {
            id:distanceLoader
            interval: 5000;
            running: false;
            repeat: true
            onTriggered: {
                Myfunc.get_time();
                buslist_model.clear();
                Mydbs.clear_running_busses(); // check if needed
                if (!page.downloading){
                    python.startDownload(selections.get(0).trip_id, cityname, selections.get(0).start_time);
                }
            }
        }

        Button {
            id:bottombutton
            text: "Check busses"
            enabled: !page.downloading
            anchors.bottom: parent.bottom
            width: parent.width
            onClicked: {
                buslist_model.clear();
                Mydbs.clear_running_busses();
                if (bus.text !== "") {
                    if (cityname == "jyvaskyla") {
                        if(bus.text.length > 1){
                            var _search = "9" + bus.text
                        }
                        else {
                            _search = "90" + bus.text
                        }
                    }
                    else {
                        _search = bus.text
                    }

                    python.startDownload(_search, cityname, "00:00:01");
                    //console.log("bus.text", bus.text)
                }
                else {
                    python.startDownload("haku", cityname, "00:00:01");
                }
            }
        }

        Python {
            id: python

            Component.onCompleted: {
                addImportPath(Qt.resolvedUrl('.'));

                setHandler('progress', function(ratio) {
                    dlprogress.value = ratio;
                });
                setHandler('message', function(msg) {
                    //console.log(msg);
                });
                setHandler('bus_id', function(msg1,msg2,msg3,msg4) {
                    //console.log(msg1, msg2, msg3,msg4);
                    //buslist_model.append({"line": msg1, "time":msg2, "label":msg3, "licenseplate":msg4})
                    Mydbs.running_busses(msg1, msg2, msg3, msg4)
                });
                setHandler('position', function(latti, longi, p3, p4, p5, p6) {
                    var coord = possut.position.coordinate
                    selections.set(0, {"dist_bus":Myfunc.distance(latti,longi,coord.latitude,coord.longitude)});
                    selections.set(0, {"dist_bus_to_stop":Myfunc.distance(latti,longi,selections.get(0).stop_lat,selections.get(0).stop_lon)});
                    selections.set(0, {"dist_me":Myfunc.distance(selections.get(0).stop_lat,selections.get(0).stop_lon,coord.latitude,coord.longitude)});
                    positsione.text = p6 + " " + Mydbs.get_stop_name(p3) + " (" + p4 + " " + p5 + ")";
                    selections.set(0,{"stop_sequence":p4})
                    competition.text = "Me " + selections.get(0).dist_me + " m - The bus " + selections.get(0).dist_bus + " m"
                });
                setHandler('finished', function(newvalue) {
                    page.downloading = false;
                    //console.log( "finished" , newvalue);
                });

                importModule('datadownloader', function () {});

            }

            function startDownload(arg1, arg2, arg3) {
                page.downloading = true;
                dlprogress.value = 0.0;
                //console.log("arg1",arg1)
                call('datadownloader.downloader.download', [arg1, arg2, arg3],function() {});
            }

            onError: {
                // when an exception is raised, this error handler will be called
                //console.log('python error: ' + traceback);
            }

            onReceived: {
                // asychronous messages from Python arrive here
                // in Python, this can be accomplished via pyotherside.send()
                //console.log('got message from python: ' + data);
            }
        }
    }
    Component.onCompleted: {
        Myfunc.get_time();
    }
}

