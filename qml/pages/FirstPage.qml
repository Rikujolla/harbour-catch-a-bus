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
                    Myfunc.closest_stop()
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
                    //text:selected_busstop.get(0).stop_name + busstops_xml.get(6).stop_id
                    text: "some text"
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("StopSchedule.qml"))
                }
            }

            SectionHeader { text: qsTr("Selected bus connection") }

            TextField {
                id: bus
                //anchors.top: header.bottom
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
                height: buslist.height
                ListView {
                    id:buslist
                    model:selected_busses
                    height:selected_busses.count*100
                    //anchors.top: bus.bottom
                    delegate: Text {
                        color: Theme.primaryColor
                        font.pixelSize:Theme.fontSizeLarge
                        text: line + " " + time + " " + label + " " + licenseplate
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: Theme.paddingLarge
                        }
                    }
                }
            }

            /*Label {
            id: mainLabel
            //anchors.verticalCenter: parent.verticalCenter
            text: "Tripinfo"
            visible: !page.downloading
            anchors.horizontalCenter: parent.horizontalCenter
        }*/

            Label {
                id: positsione
                //anchors.top: mainLabel.bottom
                text: "Testi"
                font.pixelSize:Theme.fontSizeLarge
                visible: !page.downloading
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ProgressBar {
                id: dlprogress
                label: "Downloading bus data."
                //anchors.top: mainLabel.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                visible: page.downloading
            }

            SectionHeader { text: qsTr("Me to bus competition") }

        }

        Button {
            id:deletos
            text:"Delete"
            anchors.bottom: stoptimes.top
            onClicked: Mydbs.delete_tables()
        }

        Button {
            id:stoptimes
            text:"Stop times"
            anchors.bottom: stops.top
            onClicked: Mydbs.load_stop_times()
        }

        Button {
            id:stops
            text: "Stops"
            anchors.bottom: trackbutton.top
            onClicked: Mydbs.load_stops()
        }

        Button {
            id:trackbutton
            text: "Start tracking"
            enabled: !page.downloading
            anchors.bottom: bottombutton.top
            width: parent.width
            onClicked: {
                //buslist_model.clear();
                //mainLabel.text = '';
                //python.startDownload(selected_busses.get(0).line, cityname);
                distanceLoader.start()
            }
        }

        Timer {
            id:distanceLoader
            interval: 10000;
            running: false;
            repeat: true
            onTriggered: {
                /*var minutes = 1000 * 60;
                var hours = minutes * 60;
                var days = hours * 24;
                var years = days * 365;
                var t = Date.now();
                var y = Math.round(t / years);
                var d = Math.round(t / days);
                var h = Math.round(t / hours);
                var m = Math.round(t / minutes);
                m = m-y*365*24*60;
                h = Math.round(m / 60);
                m = m-h*60
                h < 10 ? h= "0"+h: h=h

                m < 10 ? m= "0"+m: m=m
                current_time = h + ":"+ m + ":00"*/
                //console.log("m,h", m,h)
                var d = new Date();
                var n = d.toLocaleTimeString();
                //console.log(n, n.substr(0, 2),n.substr(3, 2),n.substr(6, 2) )
                current_time = n.substr(0,2) + ":" + n.substr(3,2) + ":" + n.substr(6, 2)
                if (!page.downloading){
                    python.startDownload(selected_busses.get(0).line, cityname);
                }
            }
        }

        Button {
            id:bottombutton
            text: "Check busses"
            enabled: !page.downloading && busstops_xml.status == 1
            anchors.bottom: parent.bottom
            width: parent.width
            onClicked: {
                buslist_model.clear();
                //mainLabel.text = '';
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

                    python.startDownload(_search, cityname);
                    console.log("bus.text", bus.text)
                }
                else {
                    python.startDownload("haku", cityname);
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
                    console.log(msg);
                });
                setHandler('bus_id', function(msg1,msg2,msg3,msg4) {
                    console.log(msg1, msg2, msg3,msg4);
                    //mainLabel.text = mainLabel.text + msg1 + " " + msg2 + " " + msg3 + " " + msg4
                    buslist_model.append({"line": msg1, "time":msg2, "label":msg3, "licenseplate":msg4})

                });
                setHandler('position', function(latti,longi,p3, p4,p5,p6) {
                    console.log(latti, longi, p3, p4, p5, p6);
                    positsione.text = Myfunc.distance(latti,longi) + " " + p3 + " " + p4 + " " + p5;
                });
                setHandler('finished', function(newvalue) {
                    page.downloading = false;
                    //mainLabel.text = 'Color is ' + newvalue + '.';
                    console.log( "finished");
                });

                importModule('datadownloader', function () {});

            }

            function startDownload(arg1, arg2) {
                page.downloading = true;
                dlprogress.value = 0.0;
                console.log("arg1",arg1)
                call('datadownloader.downloader.download', [arg1, arg2],function() {});
            }

            onError: {
                // when an exception is raised, this error handler will be called
                console.log('python error: ' + traceback);
            }

            onReceived: {
                // asychronous messages from Python arrive here
                // in Python, this can be accomplished via pyotherside.send()
                console.log('got message from python: ' + data);
            }
        }
    }
    Component.onCompleted: {
        //selected_stop.text = selected_busstop.get(0).stop_name + busstops_xml.get(6).stop_id
    }
}

