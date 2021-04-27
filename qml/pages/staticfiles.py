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
import zipfile
import os
import urllib.request

def slow_function(path, ifile, ofile, country, city):
    if not os.path.exists(path):
        os.makedirs(path)
    finfile = path + ifile
    foutfile = path + ofile
        #for i in range(2):
        #pyotherside.send('progress', i/2.0)
        #time.sleep(0.5)
    #with zipfile.ZipFile(path + '209.zip') as myzip:
        #with myzip.open('stops.txt', 'rU') as myfile:
            #myfiles = myfile.read().decode('UTF-8'))
            #print(myfile.read())
            #for line in myfiles:
                #line = line.replace('"','')
                #row0 = line.split(",")
            #pyotherside.send('message', row0[0], row0[2], row[3])
    if ifile == "loaddata":
        zip_source = 'https://tvv.fra1.digitaloceanspaces.com/' + city + '.zip'
        zip_target = '/home/nemo/.local/share/harbour-catch-a-bus/' + country + '/' + city + '/' + city + '.zip'
        pyotherside.send('message', "Loaded", "all", "data!", zip_source, zip_target)
        urllib.request.urlretrieve(zip_source, zip_target)
        pyotherside.send('message', "Loaded", "all", "data!")
    elif ifile == "unzip":
        with zipfile.ZipFile('/home/nemo/.local/share/harbour-catch-a-bus/' + country + '/' + city + '/' + city + '.zip', 'r') as zip_ref:
            zip_ref.extractall('/home/nemo/.local/share/harbour-catch-a-bus/' + country + '/' + city + '/')
        pyotherside.send('message', "Unzipped", "all", "data!")
    elif ifile == "routes.txt":
        linenumber = 0
        with open (foutfile, 'w') as outfile:
                with open (finfile) as infile:
                        outfile.write('<xml>\n')
                        for line in infile:
                                line = line.replace('"','')
                                if linenumber == 0:
                                        row0 = line.split(",")
                                        linenumber = 1
                                else:
                                        outfile.write('<routes>')
                                        row = line.split(",")
                                        outfile.write('<' + row0[0] + '>' + row[0] + '</' + row0[0] + '>')
                                        outfile.write('<' + row0[2] + '>' + row[2] + '</' + row0[2] + '>')
                                        outfile.write('<' + row0[3] + '>' + row[3] + '</' + row0[3] + '>')
                                        outfile.write('</routes>'+ '\n')
                        outfile.write('</xml>\n')
        pyotherside.send('message', path, ifile, ofile, country, city)
    elif ifile == "stops.txt":
        linenumber = 0
        with open (foutfile, 'w') as outfile:
                with open (finfile) as infile:
                        outfile.write('<xml>\n')
                        for line in infile:
                                line = line.replace('"','')
                                if linenumber == 0:
                                        row0 = line.split(",")
                                        linenumber = 1
                                else:
                                        outfile.write('<stop>')
                                        row = line.split(",")
                                        outfile.write('<' + row0[0] + '>' + row[0] + '</' + row0[0] + '>')
                                        outfile.write('<' + row0[2] + '>' + row[2] + '</' + row0[2] + '>')
                                        outfile.write('<' + row0[3] + '>' + row[3] + '</' + row0[3] + '>')
                                        outfile.write('<' + row0[4] + '>' + row[4] + '</' + row0[4] + '>')
                                        outfile.write('</stop>'+ '\n')
                        outfile.write('</xml>\n')
        pyotherside.send('message', path, ifile, ofile, country, city)
    elif ifile == "stop_times.txt":
        linenumber = 0
        with open (foutfile, 'w') as outfile:
                with open (finfile) as infile:
                        outfile.write('<xml>\n')
                        for line in infile:
                                line = line.replace('"','')
                                if linenumber == 0:
                                        row0 = line.split(",")
                                        linenumber = 1
                                else:
                                        outfile.write('<stoptime>')
                                        row = line.split(",")
                                        if "_0_" in row[0]:
                                                row_null = row[0].split("_0_")
                                        elif "_1_" in row[0]:
                                                row_null = row[0].split("_1_")
                                        row_one= row_null[1].split("_")
                                        row_zero=row_null[0].split("_")
                                        if "M-P_" in row_null[0]:
                                                day = "M-P"
                                        if "L_" in row_null[0]:
                                                day = "L"
                                        if "S_" in row_null[0]:
                                                day = "S"
                                        if "koulup" in row_null[0]:
                                                day = "koulup"

                                        outfile.write('<' + 'day' + '>' + day + '</' + 'day' + '>')
                                        outfile.write('<' + row0[0] + '>' + row_zero[len(row_zero)-1] + '</' + row0[0] + '>')
                                        outfile.write('<' + 'start_time' + '>' + row_one[0][:2] + ":" + row_one[0][2:4] + ":" + row_one[0][-2:]+ '</' + 'start_time' + '>')
                                        outfile.write('<' + row0[2] + '>' + row[2] + '</' + row0[2] + '>')
                                        outfile.write('<' + row0[3] + '>' + row[3] + '</' + row0[3] + '>')
                                        outfile.write('<' + row0[4] + '>' + row[4] + '</' + row0[4] + '>')
                                        outfile.write('</stoptime>'+ '\n')
                        outfile.write('</xml>\n')
        pyotherside.send('message', path, ifile, ofile, country, city)

    elif ifile == "trips.txt":
            linenumber = 0
            with open (foutfile, 'w') as outfile:
                    with open (finfile) as infile:
                            outfile.write('<xml>\n')
                            for line in infile:
                                    line = line.replace('"','')
                                    if linenumber == 0:
                                            row0 = line.split(",")
                                            linenumber = 1
                                    else:
                                            outfile.write('<trips>')
                                            row = line.split(",")
                                            outfile.write('<' + row0[0] + '>' + row[0] + '</' + row0[0] + '>')
                                            outfile.write('<' + row0[2] + '>' + row[2] + '</' + row0[2] + '>')
                                            outfile.write('</trips>'+ '\n')
                            outfile.write('</xml>\n')
            pyotherside.send('message', path, ifile, ofile, country, city)

    else:
        pyotherside.send('message', "path", "ifile", "ofile", "country", "city")

class Sloader:
    def __init__(self):
        # Set bgthread to a finished thread so we never
        # have to check if it is None.
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def download(self, path, ifile, ofile, country, city):
        self.path = path
        self.ifile = ifile
        self.ofile = ofile
        self.country = country
        self.city = city
        if self.bgthread.is_alive():
            return
        self.bgthread = threading.Thread(target=slow_function, args=(self.path,self.ifile,self.ofile,self.country,self.city,))
        self.bgthread.start()


sloader = Sloader()

