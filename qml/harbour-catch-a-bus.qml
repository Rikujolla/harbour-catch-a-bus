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
import QtQuick.LocalStorage 2.0
import "pages/dbfunctions.js" as Mydbs
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
    property string bus_start_time: "00:00:01"
    property string bus_label: "PUPUHUHTA"
    property string current_time:"00:00:00"
    property int stop_index: 0
    property string day:"M-P"
    property string version: "0.1.4"
    //Cityinfo, maybe later to be included in a ListModel
    //property string city: "Jyväskyla"
    //property string cityname: "jyvaskyla"
    //property string citynumber: "209" // 209 means Jyväskylä, not necessarily number, may be other code also
    //property string country_name: "Finland"
    //property string country: "fin"


    PositionSource {
        id: possut
        updateInterval: Qt.application.active ? rateAct : (inSleep ? rateSleep/2 : ratePass*4/5)
        active: gpsTrue
    }

    ListModel {
        id:buslist_model
        ListElement {
            line: '12'
            route_short_name: ''
            time:'08:00:00'
            label:'KUOKKALA'
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

// This model is used for busstops close to me
    ListModel {
        id:selected_busstop
        ListElement {
            stop_id: '207673'
            stop_name:'Not selected'
            stop_lat:0.0
            stop_lon: 0.0
            dist_me: 40000.0
            dist_bus: 40000.0
        }
    }

    ListModel {
        // Document selections to visualize them
        id:selections
        ListElement {
            route_short_name: ''
            stop_id: 'Not selected'
            stop_name:'Not selected'
            stop_lat:0.0
            stop_lon: 0.0
            stop_sequence:0 //Current_stop_sequence
            stop_sequence_selected:0 //Stop_sequence of the current stop for selected trip
            dist_me: 40000.0 //My distance to a selected bus stop
            trip_id:'Not selected'
            start_time: 'Not selected'
            label: 'Not selected'
            license_plate:""
            dist_bus: 40000.0 // The bus distance to me
            dist_bus_to_stop: 40000.0 //The bus distance to a bus stop
            city: "" // Jyväskylä
            cityname: "" //jyvaskyla
            citynumber: "" // E.g. 209 means Jyväskylä, not necessarily number, may be other code also
            country_name: "" // E.g. Finland
            country: "" // E.g. fin
            staticpath: "" // Path for static data zip file
            localpath: "" // If empty using default
        }
    }

    ListModel {
        // Document selections to visualize them
        id:stopseq_model
        ListElement {
            route_short_name: ''
            stop_id: 'Not selected'
            stop_name:'Not selected'
            stop_sequence:0
            colore:""
            dist_me: 40000.0
            trip_id:'Not selected'
            start_time: 'Not selected'
            planned_time:''
            label: 'Not selected'
            license_plate:""
            dist_bus: 40000.0
        }
    }
    ListModel {
        id:bus_at_stop
        ListElement {
            route_id:'9272'
            route_short_name: ''
            route_long_name: ''
            start_time: '08:00:00'
            planned_time:'07:12:00'
            label: ''
            licence_plate: 'KMT-518'
        }
    }

    Component.onCompleted: {
        Mydbs.loadSettings()
    }
}


