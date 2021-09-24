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
import io.thp.pyotherside 1.5
import QtQuick.LocalStorage 2.0
import "functions.js" as Myfunc
import "dbfunctions.js" as Mydbs

Page {
    id: page
    onStatusChanged: {
        if (selections.get(0).stop_name == ''){
            selected_stop.text = qsTr("Press to select a stop")
            bus.visible = true
            selected_bus.visible = false
        }
        else {
            selected_stop.text = selections.get(0).stop_name + ", " + selections.get(0).dist_me + " m"
            bus.visible = false
            selected_bus.visible = true
        }
        if (selections.get(0).trip_id == ''){
            selected_bus.text = qsTr("Press to select a bus")
            competition.visible = false
            positsione.visible = false
        }
        else {
            selected_bus.text = selections.get(0).route_short_name + " " + selections.get(0).start_time.substring(0,5) + " " + selections.get(0).label
            competition.visible = true
        }
        if(distanceLoader.running){
            competition.text = qsTr("Me") + " " + selections.get(0).dist_me + " " + qsTr("m") +(" - ") + qsTr("The bus") + " " + selections.get(0).dist_bus + " " + qsTr("m")
            positsione.visible = true
        }
        else {
            competition.text = qsTr("Start tracking")
        }

        pheader.description = selections.get(0).country_name + ", " + selections.get(0).city
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
            MenuItem {
                id:item1
                text: distanceLoader.running ? qsTr("Reset and stop tracking") : qsTr("Start tracking")
                //visible:distanceLoader.running
                onClicked:{
                    if(distanceLoader.running) {
                        distanceLoader.stop()
                        selections.set(0,{"stop_name":""})
                        selected_stop.text = qsTr("Press to select a stop")
                        bus.text = ""
                        selected_bus.text = ""
                        selections.set(0,{"trip_id":""})
                        positsione.text = ""
                        selections.set(0,{"dist_me":40000.0})
                        selections.set(0,{"dist_bus":40000.0})
                        competition.text = ""
                    }
                    else {
                        distanceLoader.start()
                    }
                }
            }
        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                id:pheader
                title: qsTr("Catch a bus")
                description: selections.get(0).country_name + ", " + selections.get(0).city
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
                    font.pixelSize:Theme.fontSizeLarge
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Theme.paddingLarge
                    }
                    text: ""
                }
                onClicked: {
                    if (selections.get(0).stop_name == ''){
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
                placeholderText: qsTr("Select bus line")
                anchors.horizontalCenter: parent.horizontalCenter
                validator: RegExpValidator { regExp: /^[0-9]{0,}$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                inputMethodHints:  Qt.ImhDigitsOnly
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    focus = false;

                    buslist_model.clear();
                    Mydbs.clear_running_busses();
                    if (bus.text !== "") {
                        var _search = Mydbs.get_route_id(bus.text)
                        console.log ("bas1" , selections.get(0).urlstring)
                        python.startDownload(_search, selections.get(0).cityname, "00:00:01", selections.get(0).basestring, selections.get(0).urlstring);
                    }
                    else {
                        console.log ("bas2" , selections.get(0).urlstring)

                        python.startDownload("haku", selections.get(0).cityname, "00:00:01", selections.get(0).basestring, selections.get(0).urlstring);
                    }

                }
            }

            BackgroundItem {
                Label {
                    id:selected_bus
                    //visible: selections.get(0).trip_id != ''
                    font.pixelSize:Theme.fontSizeLarge
                    wrapMode: Text.WordWrap
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Theme.paddingLarge
                    }
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

            SectionHeader { text: qsTr("Me to bus competition") }

            BackgroundItem {
                Label {
                    id:competition
                    //visible: selections.get(0).trip_id !== ''
                    font.pixelSize:Theme.fontSizeLarge
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: Theme.paddingLarge
                    }
                    text: ""
                }
                onClicked: {
                    distanceLoader.start()
                    positsione.visible = true
                    //pageStack.push(Qt.resolvedUrl("StopSchedule.qml"))
                }
            }
        }

        Timer {
            id:distanceLoader
            interval: 5000;
            running: false;
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                Myfunc.get_time();
                buslist_model.clear();
                Mydbs.clear_running_busses(); // check if needed
                if (!page.downloading){
                    console.log ("bas3" , selections.get(0).urlstring)

                    python.startDownload(selections.get(0).trip_id, selections.get(0).cityname, selections.get(0).start_time, selections.get(0).basestring, selections.get(0).urlstring);
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
                    if (developing && selections.get(0).cityname == "kuopio") {
                        var my_lat = 62.89238
                        var my_lon = 27.67703
                    }
                    else if (developing && selections.get(0).cityname == "lahti") {
                        my_lat = 60.98267
                        my_lon = 25.66151
                    }
                    else if (developing && selections.get(0).cityname == "joensuu") {
                        my_lat = 62.60118
                        my_lon = 29.76316
                    }
                    else if (developing && selections.get(0).cityname == "jyvaskyla") {
                        my_lat = 62.34578
                        my_lon = 25.67744
                    }
                    else {
                        my_lat = coord.latitude
                        my_lon = coord.longitude
                    }

                    selections.set(0, {"dist_bus":Myfunc.distance(latti,longi,my_lat,my_lon)});
                    selections.set(0, {"dist_bus_to_stop":Myfunc.distance(latti,longi,selections.get(0).stop_lat,selections.get(0).stop_lon)});
                    selections.set(0, {"dist_me":Myfunc.distance(selections.get(0).stop_lat,selections.get(0).stop_lon,my_lat,my_lon)});
                    positsione.text = p6 + " " + Mydbs.get_stop_name(p3) + " (" + p4 + ")";
                    selections.set(0,{"stop_sequence":p4})
                    competition.text = qsTr("Me") + " " + selections.get(0).dist_me + " " + qsTr("m") +(" - ") + qsTr("The bus") + " " + selections.get(0).dist_bus + " " + qsTr("m")
                });
                setHandler('finished', function(newvalue) {
                    page.downloading = false;
                    //console.log( "finished" , newvalue);
                });

                importModule('datadownloader', function () {});

            }

            function startDownload(arg1, arg2, arg3, arg4, arg5) {
                page.downloading = true;
                //dlprogress.value = 0.0;
                console.log("arg5",arg5)
                call('datadownloader.downloader.download', [arg1, arg2, arg3, arg4, arg5],function() {});
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
        pheader.description = selections.get(0).country_name + ", " + selections.get(0).city
        Mydbs.loadSettings()
    }
}

