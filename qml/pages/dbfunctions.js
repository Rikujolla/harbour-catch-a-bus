// Function loads the data from XmlListModel busstops_xml
function load_stops() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    for (var i=0;i<busstops_xml.count;i++){
                        tx.executeSql('INSERT INTO Stops VALUES(?, ?, ?, ?,?,?)', [busstops_xml.get(i).stop_id, busstops_xml.get(i).stop_name, busstops_xml.get(i).stop_lat,
                                                                                   busstops_xml.get(i).stop_lon, 0.0, 0.0])
                    }
                })
}

function load_stop_times() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    for (var i=0;i<stoptimes_xml.count;i++){
                        tx.executeSql('INSERT INTO Stop_times VALUES(?, ?, ?, ?, ?, ?)', [stoptimes_xml.get(i).day, stoptimes_xml.get(i).trip_id, stoptimes_xml.get(i).start_time,
                                                                                          stoptimes_xml.get(i).departure_time, stoptimes_xml.get(i).stop_id,
                                                                                          stoptimes_xml.get(i).stop_sequence])
                    }
                })
}

function delete_tables() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('DELETE FROM Stop_times');
                    tx.executeSql('DELETE FROM Stops');
                })
}


function get_stop_times() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM Stop_times WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    bus_at_stop.clear()
                    //console.log(current_time,stoptimes_xml.get(6).departure_time, rs.rows.length)

                    for (var i=0;i<rs.rows.length;i++){
                        if (rs.rows.item(i).stop_id == selected_busstop.get(stop_index).stop_id
                                && rs.rows.item(i).departure_time > current_time
                                && rs.rows.item(i).day == day){
                            bus_at_stop.append({"route_id":rs.rows.item(i).trip_id, "start_time":rs.rows.item(i).start_time, "planned_time":rs.rows.item(i).departure_time})
                        }
                    }

                })
}

function get_closest_stop() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM Stops');
                    var dist_smallest = 400000.0
                    var dist_temp = 400000;
                    var _thelati = 0.0
                    var _thelongi = 0.0
                    var _selected = 0;
                    for (var i=0;i<rs.rows.length;i++){
                        _thelati = (rs.rows.item(i).stop_lat)
                        _thelongi = (rs.rows.item(i).stop_lon)
                        //console.log(_thelati, _thelongi, _thelati+_thelongi)
                        dist_temp = Myfunc.distance(_thelati, _thelongi)
                        tx.executeSql('UPDATE Stops SET mydistance = ?  WHERE stop_id = ?', [dist_temp,rs.rows.item(i).stop_id])
                        if (dist_temp < dist_smallest){
                            dist_smallest = dist_temp
                            var _stopname = rs.rows.item(_selected).stop_name
                            _selected = i;
                        }
                    }

                    rs = tx.executeSql('SELECT * FROM Stops ORDER BY mydistance ASC LIMIT 15');
                    selected_busstop.clear();
                    for (i=0;i<rs.rows.length;i++){
                        selected_busstop.set(i,{"stop_id":rs.rows.item(i).stop_id, "stop_name":rs.rows.item(i).stop_name, "dist_me":rs.rows.item(i).mydistance})
                    }

                    console.log ("Pysakille " + rs.rows.item(0).stop_name + " " + dist_smallest + "m " + rs.rows.item(0).mydistance)
                    selected_stop.text = _stopname + ", " + dist_smallest + "m"
                    //selected_busstop.clear();
                    //selected_busstop.set(0,{"stop_id":rs.rows.item(0).stop_id, "stop_name":rs.rows.item(0).stop_name})
                })
}

function clear_running_busses() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Busses(route_id TEXT, start_time TEXT, label TEXT, license_plate TEXT)');
                    tx.executeSql('DELETE FROM Busses');
                })
}

function running_busses(msg1, msg2, msg3, msg4) {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Busses(route_id TEXT, start_time TEXT, label TEXT, license_plate TEXT)');
                    tx.executeSql('INSERT INTO Busses VALUES (?,?,?,?)', [msg1, msg2, msg3, msg4]);
                })
}

function running_busses_on_the_stop() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Busses(route_id TEXT, start_time TEXT, label TEXT, license_plate TEXT)');
                    if (selections.get(0).stop_name != 'Not selected'){
                        var rs = tx.executeSql('SELECT * FROM Busses INNER JOIN Stop_times on Stop_times.trip_id = Busses.route_id AND Stop_times.start_time = Busses.start_time AND Stop_times.stop_id = ? ORDER BY start_time, route_id LIMIT 1;', [selections.get(0).stop_id]);
                    }
                    else {
                        rs = tx.executeSql('SELECT * FROM Busses');
                    }

                    buslist_model.clear();
                    console.log(rs.rows.length);
                    for (var i = 0; i<rs.rows.length; i++){
                        console.log (rs.rows.item(i).route_id, rs.rows.item(i).start_time,rs.rows.item(i).label,rs.rows.item(i).license_plate)
                        buslist_model.append({"line": rs.rows.item(i).route_id, "time":rs.rows.item(i).start_time, "label":rs.rows.item(i).label, "licenseplate":rs.rows.item(i).license_plate})
                    }
                })
}
