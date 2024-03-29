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
        //console.log(city_xml.get(0).citynumber)
    }

    SilicaListView {
        id: listView
        model: country_list
        anchors.fill: parent

        /*PullDownMenu {
            MenuItem {
                text: qsTr("Stop sequence")
                onClicked:{
                }
            }
            MenuItem {
                text: qsTr("Reload")
                onClicked:{
                }
            }
        }*/

        header: PageHeader {
            title: qsTr("Country selection")
            //description: qsTr("Stop time, Stop name")
        }
        delegate: BackgroundItem {
            id: delegate

            Label {
                id: listos
                x: Theme.paddingLarge
                text: country_name_a
                //font.bold: index < selections.get(0).stop_sequence ? true:false
                //font.italic: index < selections.get(0).stop_sequence ? true:false
                anchors.verticalCenter: parent.verticalCenter
                //color: colore == "first" ? Theme.secondaryHighlightColor : Theme.primaryColor
            }
            onClicked: {
                selections.set(0,{"country_name": country_name_a})
                selections.set(0,{"country": country_a})
                selections.set(0,{"city": ""})
                selections.set(0,{"cityname": ""})
                selections.set(0,{"citynumber": ""})
                selections.set(0,{"urlstring": ""})
                selections.set(0,{"staticpath": ""})
                selections.set(0,{"gtfsversion": ""})
                selections.set(0,{"basestring": ""})
                console.log(country_name_a, country_a)
                Mydbs.saveSettings();
                pageStack.pop();

            }
        }


        ListModel {
            id: country_list
            ListElement {
                country_name_a:""
                country_a:""
            }
        }


        VerticalScrollDecorator {}

        Component.onCompleted: {

            Mydbs.fill_country();
        }
    }
}
