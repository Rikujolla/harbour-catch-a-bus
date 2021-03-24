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

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "dbfunctions.js" as Mydbs

Page {
    id: page
    onStatusChanged: {
    }

    SilicaListView {
        id: listView
        model: buslist_model
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Busses available")
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("Loc.qml"))
                }
            }
        }

        header: PageHeader {
            title: qsTr("Select your bus")
            description: {
                if (selections.get(0).stop_name == 'Not selected') {qsTr("All currently running busses")}
                else {qsTr("Currently running busses of the selected stop")}
            }
        }
        delegate: BackgroundItem {
            id: delegate

            Label {
                id: listos
                x: Theme.paddingLarge
                text: route_short_name + " " + time.substring(0,5) + " " + label + " " + licenseplate
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                selections.set(0, {"route_short_name": route_short_name, "trip_id":line, "start_time":time, "label":label, "license_plate":licenseplate})
                pageStack.pop();
            }
        }
        VerticalScrollDecorator {}

        Component.onCompleted: {
            Mydbs.running_busses_on_the_stop()
        }
    }
}
