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
import QtQuick.LocalStorage 2.0
import "dbfunctions.js" as Mydbs
import QtQuick.XmlListModel 2.0

Page {
    id: page
    onStatusChanged: {
        country_setting.text = qsTr("Selected country") + (": ") + selections.get(0).country_name
        city_setting.text = qsTr("Selected city") + (": ") + selections.get(0).city
        selections.get(0).city !== "" ? load_static_data.enabled = true : load_static_data.enabled = false
    }

    SilicaFlickable {
        anchors.fill: parent

        /*PullDownMenu {
            MenuItem {
                text: qsTr("Select country")
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("SelectCountry.qml"))
                }
            }
            MenuItem {
                text: qsTr("Select city")
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("SelectCity.qml"))
                }
            }
        }*/

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Settings page")
            }

            Text {
                id: country_setting
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }

            Button {
                text:qsTr("Select country")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Mydbs.load_city_data();
                    pageStack.push(Qt.resolvedUrl("SelectCountry.qml"))
                }
            }

            Text {
                id:city_setting
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }

            Button {
                text:qsTr("Select city")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SelectCity.qml"))
                }
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
                text: {
                    qsTr("Load and edit static data!")
                }
            }

            Button {
                id:load_static_data
                text:qsTr("Load static data")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("LoadStatic.qml"))
                }
            }

            XmlListModel {
                id: city_xml
                source: "../data/city.xml"
                query: "/xml/city"
                XmlRole {name:"country_name"; query:"country_name/string()"}
                XmlRole {name:"country"; query:"country/string()"}
                XmlRole {name:"city"; query:"city/string()"}
                XmlRole {name:"cityname"; query:"cityname/string()"}
                XmlRole {name:"citynumber"; query:"citynumber/string()"}
                XmlRole {name:"staticpath"; query:"staticpath/string()"}
                XmlRole {name:"gtfsversion"; query:"gtfsversion/string()"}
            }

        }
    }

    Component.onCompleted: {
        Mydbs.loadSettings();
    }
}
