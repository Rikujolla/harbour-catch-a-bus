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

Page {
    id: page

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

            Button {
                text:"Load stops"
                enabled:busstops_xml.status == 1
                onClicked: Mydbs.load_stops()
            }

            Button {
                text:"Load stop times"
                enabled: stoptimes_xml.status == 1
                onClicked: Mydbs.load_stop_times()
            }
            Button {
                text:"Delete old data"
                onClicked: Mydbs.delete_tables()
            }

            XmlListModel {
                id: stoptimes_xml
                source: "../data/209/stop_times.xml"
                query: "/xml/stoptime"
                XmlRole {name:"day"; query:"day/string()"}
                XmlRole {name:"trip_id"; query:"trip_id/string()"}
                XmlRole {name:"start_time"; query:"start_time/string()"}
                XmlRole {name:"departure_time"; query:"departure_time/string()"}
                XmlRole {name:"stop_id"; query:"stop_id/string()"}
                XmlRole {name:"stop_sequence"; query:"stop_sequence/number()"}
            }
        }
    }
}
