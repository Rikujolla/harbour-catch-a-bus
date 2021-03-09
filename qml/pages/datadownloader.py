#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#  Copyright (C) 2015 Jolla Ltd.
#  Contact: Jussi Pakkanen <jussi.pakkanen@jolla.com>
#  All rights reserved.
#
#  You may use this file under the terms of BSD license as follows:
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the Jolla Ltd nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This file demonstrates how to write a class that downloads data from the
# net, does heavy processing or some other operation that takes a long time.
# To keep the UI responsive we do the operations in a separate thread and
# send status updates via signals.

import pyotherside
import threading
import time
import random
import urllib.request
import base64
from google.transit import gtfs_realtime_pb2

colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet']

def slow_function(bus, city, starttime):
    #for i in range(2):
        #pyotherside.send('progress', i/2.0)
        #time.sleep(0.5)
    #pyotherside.send('message', 'Muuttujan alustus')
    request = urllib.request.Request("https://data.waltti.fi/" + city + "/api/gtfsrealtime/v1.0/feed/tripupdate")
    base64string = "ODA2Mzc2NDg0OTQxOTkwNjpQZHhqYXlTV0c2NWpURkVMQjU0Z2E2dHBMRWt0cnRZbg=="
    request.add_header("Authorization", "Basic %s" % base64string)
    response = urllib.request.urlopen(request)
    feed = gtfs_realtime_pb2.FeedMessage()
    feed.ParseFromString(response.read())
    for entity in feed.entity:
        if entity.HasField('trip_update'):
            if bus == "haku" or bus in entity.trip_update.trip.route_id:
                route_id = entity.trip_update.trip.route_id
                start_time = entity.trip_update.trip.start_time
                label = entity.trip_update.vehicle.label
                license_plate = entity.trip_update.vehicle.license_plate
                pyotherside.send('bus_id', route_id, start_time, label, license_plate)
    pyotherside.send('finished', random.choice(colors))

    request = urllib.request.Request("https://data.waltti.fi/" + city + "/api/gtfsrealtime/v1.0/feed/vehicleposition")
    base64string = "ODA2Mzc2NDg0OTQxOTkwNjpQZHhqYXlTV0c2NWpURkVMQjU0Z2E2dHBMRWt0cnRZbg=="
    request.add_header("Authorization", "Basic %s" % base64string)
    response = urllib.request.urlopen(request)
    feed2 = gtfs_realtime_pb2.FeedMessage()
    feed2.ParseFromString(response.read())

    for entity in feed2.entity:
        if entity.HasField('vehicle'):
            if bus in entity.vehicle.trip.route_id and starttime in entity.vehicle.trip.start_time:
            #if license_plate in entity.vehicle.trip.route_id and starttime in entity.vehicle.trip.start_time:
                latitude = entity.vehicle.position.latitude
                longitude = entity.vehicle.position.longitude
                stop_id = entity.vehicle.stop_id
                current_stop_sequence = entity.vehicle.current_stop_sequence
                current_status = entity.vehicle.current_status
                license_plate = entity.vehicle.vehicle.license_plate
                pyotherside.send('position', latitude, longitude, stop_id, current_stop_sequence, current_status, license_plate)

class Downloader:
    def __init__(self):
        # Set bgthread to a finished thread so we never
        # have to check if it is None.
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def download(self, bus, city, starttime):
        self.bus = bus
        self.city = city
        self.starttime = starttime
        if self.bgthread.is_alive():
            return
        self.bgthread = threading.Thread(target=slow_function, args=(self.bus, self.city, self.starttime,))
        self.bgthread.start()


downloader = Downloader()

