/*
  Copyright (C) 2015 Jolla Ltd.
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
import QtQuick.LocalStorage 2.0
import io.thp.pyotherside 1.4
import "../pages/dbfunctions.js" as Mydbs

CoverBackground {
    Image{
        id: bg_image
        source:"../images/harbour-catch-a-bus-coverpage-256.png"
        opacity: 0.2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        text: qsTr("Catch a bus")
        anchors.topMargin: Theme.paddingLarge
        x: Theme.paddingLarge
    }
    Label {
        id: label2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label.bottom
        text: selections.get(0).route_short_name
        anchors.topMargin: Theme.paddingMedium
        x: Theme.paddingLarge
    }
    Label {
        id: label3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label2.bottom
        //text: (selections.get(0).stop_sequence_selected - selections.get(0).stop_sequence) + " stops"
        text: (selections.get(0).stop_sequence) + " stops"
        anchors.topMargin: Theme.paddingMedium
        x: Theme.paddingLarge
    }
    Label {
        id: label4
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label3.bottom
        text: "Bus " + selections.get(0).dist_bus_to_stop + " m"
        anchors.topMargin: Theme.paddingMedium
        x: Theme.paddingLarge
    }
    Label {
        id: label5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label4.bottom
        text: "Me " + selections.get(0).dist_me + " m"
        anchors.topMargin: Theme.paddingMedium
        x: Theme.paddingLarge
    }
    Label {
        id: label6
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label5.bottom
        text: "RUN!"
        anchors.topMargin: Theme.paddingMedium
        x: Theme.paddingLarge
    }

    Timer {
        repeat: true
        interval: 1000
        running: true && status == 2
        onTriggered: {
            label2.text = selections.get(0).route_short_name
            Mydbs.fill_sequence(day,selections.get(0).trip_id,selections.get(0).start_time)
            //console.log("statuscover", status)
            if ((selections.get(0).stop_sequence_selected - selections.get(0).stop_sequence)<0){
                label3.text = qsTr("Bus passed")
            }
            else {
                label3.text = (selections.get(0).stop_sequence_selected - selections.get(0).stop_sequence) + " stops"
            }
            label4.text = "Bus " + selections.get(0).dist_bus_to_stop + " m"
            var _time_bus = selections.get(0).dist_bus_to_stop/16.6 //Estimating bus speed about 60 km/h
            var _my_speed_needed = selections.get(0).dist_me/(_time_bus + 30.0)

            label5.text = "Me " + selections.get(0).dist_me + " m"

            if (((selections.get(0).stop_sequence_selected - selections.get(0).stop_sequence)<0) && selections.get(0).dist_bus < 30.0){ //
                label6.text = qsTr("IN THE BUS!")
                label6.color = "green"
            }
            else if (((selections.get(0).stop_sequence_selected - selections.get(0).stop_sequence)<0) && selections.get(0).dist_bus >= 30.0){ //
                label6.text = qsTr("YOU LOST!")
                label6.color = "red"
            }
            else if (_my_speed_needed < 0.7 ) {
                label6.text = qsTr("HOLD!")
                label6.color = "white"
            }
            else if (_my_speed_needed < 1.4) {
                label6.text = qsTr("WALK!")
                label6.color = "green"
            }
            else if (_my_speed_needed < 2.8){
                label6.text = qsTr("JOG!")
                label6.color = "yellow"
            }
            else if (_my_speed_needed < 4.2){
                label6.text = qsTr("RUN!")
                label6.color = "orange"
            }
            else {
                label6.text = qsTr("YOU LOST!")
                label6.color = "red"
            }
            //console.log(selections.get(0).dist_bus_to_stop, selections.get(0).dist_bus, selections.get(0).dist_me)
        }
    }

    /*CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: python.call('coveractions.action_next', [], function(newstring) {
                label.text = newstring;
            });
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
            onTriggered: python.call('coveractions.action_pause', [], function(newstring) {
                label.text = newstring;
            });
        }
    }*/

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));
            importModule('coveractions', function () {});
        }
    }
}


