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
import QtPositioning 5.4
import QtQuick.XmlListModel 2.0
import "pages"

ApplicationWindow
{
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    property int rateAct: 900 // Timers update rate when active
    property int ratePass: 15000 // Timers update when application not active but tracking
    property int rateSleep: 300000 // Timers when nothing happens, long away from tracking areas
    property bool inSleep: false
    property bool gpsTrue: true

    property string bus_line: "18"
    property string bus_start_time: "00:00:00"
    property string bus_label: "PUPUHUHTA"
    property string citynumber: "209" // 209 means Jyväskylä
    property string cityname: "jyvaskyla"
    property string current_time:"00:00:00"


    PositionSource {
        id: possut
        updateInterval: Qt.application.active ? rateAct : (inSleep ? rateSleep/2 : ratePass*4/5)
        active: gpsTrue
    }

    ListModel {
        id:buslist_model
        ListElement {
            line: '12'
            time:'08:00:00'
            label:'KUOKKALA'
            licenseplate: 'CCC-111'
        }
    }

    ListModel {
        id:selected_busses
        ListElement {
            line: '18'
            time:'00:00:00'
            label:'PUPUHUHTA'
            licenseplate: 'CCC-111'
        }
    }

    ListModel {
        id:busstop_model
        ListElement {
            stop_id: '10000000'
            stop_name:'Puuppolan eritasoliittymä 1'
            stop_lat:'62.35482864741343'
            stop_lon: '25.707038504557797'
        }

    }
    ListModel {
        id:selected_busstop
        ListElement {
            stop_id: '207673'
            stop_name:'Poratie 1'
            stop_lat:'62.2838474770924'
            stop_lon: '25.7925898402179'
        }

    }

    ListModel {
        id:bus_at_stop
        ListElement {
            route_id:'9272'
            start_time: '08:00:00'
            planned_time:'07:12:00'
            licence_plate: 'KMT-518'
        }

    }

    XmlListModel {
        id: busstops_xml
        //source: !testData ? "data/lamstations.xml" : "https://github.com/Rikujolla/trafficviewer/tree/master/qml/data/lamstations.xml"
        source: "data/209/stops.xml"
        query: "/xml/stop"
        XmlRole {name:"stop_id"; query:"stop_id/string()"}
        XmlRole {name:"stop_name"; query:"stop_name/string()"}
        XmlRole {name:"stop_lat"; query:"stop_lat/number()"}
        XmlRole {name:"stop_lon"; query:"stop_lon/number()"}
        //XmlRole {name:"LAM_NUMERO"; query:"LAM_NUMERO/number()"}
    }

    XmlListModel {
        id: stoptimes_xml
        //source: !testData ? "data/lamstations.xml" : "https://github.com/Rikujolla/trafficviewer/tree/master/qml/data/lamstations.xml"
        source: "data/209/stop_times.xml"
        query: "/xml/stoptime"
        XmlRole {name:"day"; query:"day/string()"}
        XmlRole {name:"trip_id"; query:"trip_id/string()"}
        XmlRole {name:"start_time"; query:"start_time/string()"}
        XmlRole {name:"departure_time"; query:"departure_time/string()"}
        XmlRole {name:"stop_id"; query:"stop_id/string()"}
        XmlRole {name:"stop_sequence"; query:"stop_sequence/number()"}
    }

    Component.onCompleted: {
        //console.log (busstops_xml.get(6).stop_id)
    }
}

