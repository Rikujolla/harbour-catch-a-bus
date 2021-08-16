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
        //Mydbs.get_buss_stops()
    }

    SilicaListView {
        id: listView
        model: busstop_model
        anchors.fill: parent

        /*PullDownMenu {
            MenuItem {
                text: qsTr("Clear busses")
                onClicked:{
                    pageStack.pop();
                }
            }
        }*/

        header: BackgroundItem {
            enabled: false
            height: header_part.height + search_part.height
            PageHeader {
                id: header_part
                title: qsTr("Select my stops")
                description: qsTr("Stop names in alphabetical order")
            }

            SearchField{
                id:search_part
                anchors.top: header_part.bottom
                width: parent.width
                placeholderText: "Search"

                onTextChanged: {
                    if (text.length >2) {
                        Mydbs.get_buss_stops(text)
                        //search_part.cursorPosition = search_part.text.length
                        //forceActiveFocus()
                    }
                    else {console.log(text)}
                }
            }
        }

        delegate: BackgroundItem {
            id: delegate

            Label {
                id: listos
                x: Theme.paddingLarge
                text: stop_name
                anchors.verticalCenter: parent.verticalCenter
                color: my_stop == 1 ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                //my_stop == 1 ? my_stop = 0 : my_stop = 1
                if (my_stop == 0){
                    Mydbs.add_my_stops(1, stop_id, stop_name, my_stop, "");
                    my_stop = 1
                    console.log("mystop 0->1")
                }
                else {
                    Mydbs.add_my_stops(0, stop_id, stop_name, my_stop, "");
                    my_stop == 0
                    console.log("mystop 1->0")
                }

                Mydbs.get_buss_stops("");
            }
        }
        VerticalScrollDecorator {}

        Component.onCompleted: {
            Mydbs.get_buss_stops("")
        }
    }
}
