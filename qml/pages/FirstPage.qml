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
import "functions.js" as Myfunc
Page {

    id: page
    property bool downloading: false

    PageHeader {
        id: header
        width: parent.width
        title: "Catch a bus"
    }

    TextField {
        id: bus
        anchors.top: header.bottom
        placeholderText: "Enter bus line"
        anchors.horizontalCenter: parent.horizontalCenter
        validator: RegExpValidator { regExp: /^[0-9]{4,4}$/ }
        color: errorHighlight? "red" : Theme.primaryColor
        inputMethodHints:  Qt.ImhDigitsOnly
        EnterKey.enabled: !errorHighlight
        EnterKey.iconSource: "image://theme/icon-m-enter-close"
        EnterKey.onClicked: {
            focus = false;
        }
    }

    Label {
        id: mainLabel
        anchors.verticalCenter: parent.verticalCenter
        text: "Tripinfo"
        visible: !page.downloading
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: positsione
        anchors.top: mainLabel.bottom
        text: "Testi"
        visible: !page.downloading
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ProgressBar {
        id: dlprogress
        label: "Downloading latest color trends."
        anchors.top: mainLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        visible: page.downloading
    }

    Button {
        text: "Check busses"
        enabled: !page.downloading
        anchors.bottom: parent.bottom
        width: parent.width
        onClicked: {
            mainLabel.text = '';
            python.startDownload();
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
            setHandler('bus_id', function(msg1,msg2,msg3) {
                console.log(msg1, msg2, msg3);
                mainLabel.text = mainLabel.text + msg1 + " " + msg2 + " " + msg3
            });
            setHandler('position', function(latti,longi,p3, p4,p5,p6) {
                console.log(latti, longi, p3, p4, p5, p6);
                positsione.text = Myfunc.distance(latti,longi);
            });
            setHandler('finished', function(newvalue) {
                page.downloading = false;
                //mainLabel.text = 'Color is ' + newvalue + '.';
                console.log( "finished");
            });

            importModule('datadownloader', function () {});

        }

        function startDownload() {
            page.downloading = true;
            dlprogress.value = 0.0;
            call('datadownloader.downloader.download', [bus.text],function() {});
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


