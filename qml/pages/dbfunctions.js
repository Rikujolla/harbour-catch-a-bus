// Function loads the data from XmlListModel busstops_xml
function load_stops() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Mystops(stop_id TEXT, stop_name TEXT, my_stop INTEGER)');
                    for (var i=0;i<busstops_xml.count;i++){
                        tx.executeSql('INSERT INTO Stops VALUES(?,?,?,?,?,?,?)', [busstops_xml.get(i).stop_id, busstops_xml.get(i).stop_name, busstops_xml.get(i).stop_lat,
                                                                                  busstops_xml.get(i).stop_lon, 0.0, 0.0, 0])
                    }

                    tx.executeSql('UPDATE Stops SET my_stop = (SELECT my_stop FROM Mystops WHERE Mystops.stop_id = Stops.stop_id) where EXISTS (SELECT my_stop FROM Mystops WHERE Mystops.stop_id = Stops.stop_id)');

                })
}

function get_my_stops() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Mystops(stop_id TEXT, stop_name TEXT, my_stop INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM Mystops');

                    selected_stops = [];
                    for (var i=0;i<rs.rows.length;i++){
                        selected_stops.push(rs.rows.item(i).stop_id)
                    }


                })
}

function get_buss_stops(_text) {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Mystops(stop_id TEXT, stop_name TEXT, my_stop INTEGER)');
                    if (_text == ""){
                        var rs = tx.executeSql('SELECT * FROM Stops ORDER BY my_stop DESC, stop_name ASC', []);
                    }
                    else {
                        rs = tx.executeSql('SELECT * FROM Stops WHERE stop_name LIKE ? ORDER BY my_stop DESC, stop_name ASC', ['%' + _text + '%']);
                    }

                    busstop_model.clear();
                    for (var i=0;i<rs.rows.length;i++){
                        busstop_model.set(i,{"stop_id":rs.rows.item(i).stop_id, "stop_name":rs.rows.item(i).stop_name, "my_stop":rs.rows.item(i).my_stop})
                    }

                    tx.executeSql('UPDATE Stops SET my_stop = (SELECT my_stop FROM Mystops WHERE Mystops.stop_id = Stops.stop_id) where EXISTS (SELECT my_stop FROM Mystops WHERE Mystops.stop_id = Stops.stop_id)');

                })
}

function add_my_stops(_add, _stop_id, _stop_name, _my_stop, _text) {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Mystops(stop_id TEXT, stop_name TEXT, my_stop INTEGER)');
                    if (_add == 1){
                        tx.executeSql('INSERT INTO Mystops VALUES(?, ?, ?)', [_stop_id, _stop_name, _add])
                        tx.executeSql('UPDATE Stops SET my_stop = ? WHERE stop_id = ?', [_add, _stop_id])
                    }
                    else if (_add==0) {
                        tx.executeSql('DELETE FROM Mystops WHERE stop_id = ?', [_stop_id])
                        tx.executeSql('UPDATE Stops SET my_stop = ? WHERE stop_id = ?', [_add, _stop_id])
                    }

                    //tx.executeSql('UPDATE Stops SET my_stop = (SELECT my_stop FROM Mystops WHERE Mystops.stop_id = Stops.stop_id) where EXISTS (SELECT my_stop FROM Mystops WHERE Mystops.stop_id = Stops.stop_id)');

                    if (_text == ""){
                        var rs = tx.executeSql('SELECT * FROM Stops ORDER BY my_stop DESC, stop_name ASC', []);
                    }
                    else {
                        rs = tx.executeSql('SELECT * FROM Stops WHERE stop_name LIKE ? ORDER BY my_stop DESC, stop_name ASC', ['%' + _text + '%']);
                    }

                    busstop_model.clear();
                    for (var i=0;i<rs.rows.length;i++){
                        busstop_model.set(i,{"stop_id":rs.rows.item(i).stop_id, "stop_name":rs.rows.item(i).stop_name, "my_stop":rs.rows.item(i).my_stop})
                    }
                })
}

function get_stop_name(_name) {

    var rs
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    rs = tx.executeSql('SELECT * FROM Stops WHERE stop_id = ?', [_name]);
                })
    return rs.rows.item(0).stop_name
}

function get_route_id(_id) {

    var rs
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Routes(route_id TEXT, route_short_name TEXT, route_long_name TEXT)');
                    rs = tx.executeSql('SELECT route_id FROM Routes WHERE route_short_name = ?', [_id]);
                })
    if (rs.rows.length>0){
        var _value = rs.rows.item(0).route_id
        console.log(rs.rows.item(0).route_id)
    }

    else {
        _value = ""
    }

    return _value
}


function load_stop_times() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    if(developing){console.log("Items in stop_times.xml", stoptimes_xml.count)}
                    for (var i=0;i<stoptimes_xml.count;i++){
                        tx.executeSql('INSERT INTO Stop_times VALUES(?, ?, ?, ?, ?)', [stoptimes_xml.get(i).trip_id, stoptimes_xml.get(i).start_time,
                                                                                       stoptimes_xml.get(i).departure_time, stoptimes_xml.get(i).stop_id,
                                                                                       stoptimes_xml.get(i).stop_sequence])
                    }
                })
}

function load_routes() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Routes(route_id TEXT, route_short_name TEXT, route_long_name TEXT)');
                    //console.log("hhhhh")
                    for (var i=0;i<routes_xml.count;i++){
                        tx.executeSql('INSERT INTO Routes VALUES(?, ?, ?)', [routes_xml.get(i).route_id, routes_xml.get(i).route_short_name, routes_xml.get(i).route_long_name])
                    }
                })
}

function load_trips() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Trips(route_id TEXT, service_id TEXT, trip_id TEXT)');
                    //console.log("hhhhh trips",trips_xml.get(0).route_id, trips_xml.get(0).service_id, trips_xml.get(0).trip_id)
                    for (var i=0;i<trips_xml.count;i++){
                        tx.executeSql('INSERT INTO Trips VALUES(?, ?, ?)', [trips_xml.get(i).route_id, trips_xml.get(i).service_id, trips_xml.get(i).trip_id])
                    }
                })
}

function load_calendar() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar(service_id TEXT,monday TEXT,tuesday TEXT,wednesday TEXT,thursday TEXT,friday TEXT,saturday TEXT,sunday TEXT,start_date TEXT,end_date TEXT)');
                    for (var i=0;i<calendar_xml.count;i++){
                        tx.executeSql('INSERT INTO Calendar VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [calendar_xml.get(i).service_id, calendar_xml.get(i).monday, calendar_xml.get(i).tuesday
                                                                                                    , calendar_xml.get(i).wednesday, calendar_xml.get(i).thursday, calendar_xml.get(i).friday
                                                                                                    , calendar_xml.get(i).saturday, calendar_xml.get(i).sunday, calendar_xml.get(i).start_date
                                                                                                    , calendar_xml.get(i).end_date])
                    }
                })
}

function load_calendar_dates() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar_dates(service_id TEXT, date TEXT, exception_type TEXT)');
                    //console.log("hhhhh trips",trips_xml.get(0).route_id, trips_xml.get(0).service_id, trips_xml.get(0).trip_id)
                    for (var i=0;i<calendar_dates_xml.count;i++){
                        tx.executeSql('INSERT INTO Calendar_dates VALUES(?, ?, ?)', [calendar_dates_xml.get(i).service_id, calendar_dates_xml.get(i).date, calendar_dates_xml.get(i).exception_type])
                    }
                })
}

function delete_tables() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Routes(route_id TEXT, route_short_name TEXT, route_long_name TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Trips(route_id TEXT, service_id TEXT, trip_id TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar(service_id TEXT,monday TEXT,tuesday TEXT,wednesday TEXT,thursday TEXT,friday TEXT,saturday TEXT,sunday TEXT,start_date TEXT,end_date TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar_dates(service_id TEXT, date TEXT, exception_type TEXT)');
                    tx.executeSql('DELETE FROM Stops');
                    tx.executeSql('DELETE FROM Stop_times');
                    tx.executeSql('DELETE FROM Routes');
                    tx.executeSql('DELETE FROM Trips');
                    tx.executeSql('DELETE FROM Calendar');
                    tx.executeSql('DELETE FROM Calendar_dates');
                })
}


function get_stop_times() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Routes(route_id TEXT, route_short_name TEXT, route_long_name TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Trips(route_id TEXT, service_id TEXT, trip_id TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar_tmp(service_id TEXT, exception_type TEXT)');
                    tx.executeSql('DELETE FROM Calendar_tmp');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar_tmp2(service_id TEXT, exception_type TEXT)');
                    tx.executeSql('DELETE FROM Calendar_tmp2');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar(service_id TEXT,monday TEXT,tuesday TEXT,wednesday TEXT,thursday TEXT,friday TEXT,saturday TEXT,sunday TEXT,start_date TEXT,end_date TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar_dates(service_id TEXT, date TEXT, exception_type TEXT)');

                    // Count the day in a format of GTFS
                    var _d = new Date();
                    var _date = _d.getDate()
                    if (_date < 10){_date = "0" +_date}
                    var _month = _d.getMonth() + 1
                    if (_month < 10){_month = "0" + _month}
                    var _dateday = _d.getFullYear() + _month  + _date

                    if (_d.getDay() == 0) {
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND sunday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        var rs = tx.executeSql('SELECT start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 1) {
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND monday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 2) {
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND tuesday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 3) {
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND wednesday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 4) {
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND thursday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 5) {
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND friday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 6) {
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND saturday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                     }
                    else {
                        console.log("some error, day", _d.getDay())
                    }
                    bus_at_stop.clear()
                    if (developing) {console.log("Day", _d.getDay(),"On bus stop", selected_busstop.get(stop_index).stop_id, rs.rows.length, "busses.")}

                    for (var i=0;i<rs.rows.length;i++){
                        //console.log(rs.rows.item(i).sname, rs.rows.item(i).sname)
                        if (rs.rows.item(i).stop_id == selected_busstop.get(stop_index).stop_id
                                && rs.rows.item(i).departure_time > current_time
                                ){
                            bus_at_stop.append({"route_id":rs.rows.item(i).route_id, "route_short_name": rs.rows.item(i).route_short_name, "route_long_name": rs.rows.item(i).route_long_name, "start_time":rs.rows.item(i).start_time, "planned_time":rs.rows.item(i).departure_time})
                        }
                    }
                })
}

function get_closest_stop() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    //var rs = tx.executeSql('SELECT *, (ABS(stop_lat-?) + ABS(stop_lon-?)) AS mydist FROM Stops GROUP BY stop_id ORDER BY mydist ASC LIMIT 20', [possut.position.coordinate.latitude, possut.position.coordinate.longitude]);
                    var coord = possut.position.coordinate
                    if (developing && selections.get(0).cityname == "kuopio") {
                        var my_lat = 62.89238
                        var my_lon = 27.67703
                    }
                    else if (developing && selections.get(0).cityname == "lahti") {
                        my_lat = 60.98267
                        my_lon = 25.66151
                    }
                    else if (developing && selections.get(0).cityname == "joensuu") {
                        my_lat = 62.60118
                        my_lon = 29.76316
                    }
                    else if (developing && selections.get(0).cityname == "jyvaskyla") {
                        my_lat = 62.34578
                        my_lon = 25.67744
                    }
                    else {
                        my_lat = coord.latitude
                        my_lon = coord.longitude
                    }

                    var uplat = my_lat+0.02
                    var lowlat = my_lat-0.02
                    var uplon = my_lon+0.02
                    var lowlon = my_lon-0.02
                    console.log(lowlat, uplat, lowlon, uplon)
                    //var rs = tx.executeSql('SELECT * FROM Stops');
                    var rs = tx.executeSql('SELECT * FROM Stops WHERE stop_lat > ? AND stop_lat < ? AND stop_lon > ? AND stop_lon < ?', [lowlat, uplat, lowlon,uplon]);
                    if (developing){console.log(rs.rows.length)}
                    var dist_temp = 400000;
                    var _thelati = 0.0
                    var _thelongi = 0.0
                    var _long_away = false
                    // if the stops are long away. Mostly for testing. Could be replaced with test location.
                    if(rs.rows.length == 0){
                        if (developing){console.log(rs.rows.length)}
                        rs = tx.executeSql('SELECT * FROM Stops ORDER BY stop_name ASC LIMIT 100');
                        _long_away = true
                    }
                    // Normal condition
                    else {
                        if (developing){console.log("Normal condition", rs.rows.length)}

                        for (var i=0;i<rs.rows.length;i++){
                            _thelati = (rs.rows.item(i).stop_lat)
                            _thelongi = (rs.rows.item(i).stop_lon)
                            dist_temp = Myfunc.distance(_thelati, _thelongi,my_lat, my_lon)
                            tx.executeSql('UPDATE Stops SET mydistance = ?  WHERE stop_id = ?', [dist_temp,rs.rows.item(i).stop_id])
                        }

                        rs = tx.executeSql('SELECT * FROM Stops WHERE mydistance < ? AND mydistance > ? ORDER BY mydistance ASC', [2000, 0.0]);
                        if (developing){console.log("Number of the closest stops", rs.rows.length)}
                    }

                    selected_busstop.clear();
                    for (i=0;i<rs.rows.length;i++){
                        if (_long_away){
                            _thelati = (rs.rows.item(i).stop_lat)
                            _thelongi = (rs.rows.item(i).stop_lon)
                            dist_temp = Myfunc.distance(_thelati, _thelongi,my_lat, my_lon)
                            selected_busstop.set(i,{"stop_id":rs.rows.item(i).stop_id, "stop_name":rs.rows.item(i).stop_name, "dist_me":dist_temp, "stop_lat":rs.rows.item(i).stop_lat, "stop_lon":rs.rows.item(i).stop_lon})
                        }
                        else {
                            selected_busstop.set(i,{"stop_id":rs.rows.item(i).stop_id, "stop_name":rs.rows.item(i).stop_name, "dist_me":rs.rows.item(i).mydistance, "stop_lat":rs.rows.item(i).stop_lat, "stop_lon":rs.rows.item(i).stop_lon})
                        }
                    }
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Busses(route_id TEXT, start_time TEXT, label TEXT, license_plate TEXT)');
                    tx.executeSql('INSERT INTO Busses VALUES (?,?,?,?)', [msg1, msg2, msg3, msg4]);
                })
}

function running_busses_on_the_stop() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Busses(route_id TEXT, start_time TEXT, label TEXT, license_plate TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Routes(route_id TEXT, route_short_name TEXT, route_long_name TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Trips(route_id TEXT, service_id TEXT, trip_id TEXT)');
                    if (selections.get(0).stop_name != ''){
                        //var rs = tx.executeSql('SELECT * FROM Busses INNER JOIN Stop_times on Stop_times.trip_id = Busses.route_id AND Stop_times.start_time = Busses.start_time AND Stop_times.stop_id = ? ORDER BY start_time, route_id LIMIT 1;', [selections.get(0).stop_id]);
                        var rs = tx.executeSql('SELECT *, route_short_name, route_long_name FROM Busses INNER JOIN Trips ON Trips.route_id=Busses.route_id INNER JOIN Stop_times on Stop_times.trip_id = Trips.trip_id AND Stop_times.start_time = Busses.start_time AND Stop_times.stop_id = ? INNER JOIN Routes ON Busses.route_id = Routes.route_id ORDER BY start_time, route_id LIMIT 1;', [selections.get(0).stop_id]);
                    }
                    else {
                        rs = tx.executeSql('SELECT * FROM Busses');
                    }

                    buslist_model.clear();
                    //console.log(rs.rows.length);
                    for (var i = 0; i<rs.rows.length; i++){
                        console.log (rs.rows.item(i).route_id, rs.rows.item(i).start_time,rs.rows.item(i).label,rs.rows.item(i).license_plate)
                        buslist_model.append({"line": rs.rows.item(i).route_id, route_short_name: rs.rows.item(i).route_short_name, "time":rs.rows.item(i).start_time, "label":rs.rows.item(i).label, "licenseplate":rs.rows.item(i).license_plate})
                    }
                })
}

function fill_sequence(_day, _route_id, _start_time) {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL, my_stop INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Busses(route_id TEXT, start_time TEXT, label TEXT, license_plate TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Routes(route_id TEXT, route_short_name TEXT, route_long_name TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Trips(route_id TEXT, service_id TEXT, trip_id TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Calendar_tmp2(service_id TEXT, exception_type TEXT)');
                    var rs = tx.executeSql('SELECT *, stop_name, route_id FROM Stop_times INNER JOIN Trips ON Trips.trip_id=Stop_times.trip_id INNER JOIN Stops ON Stop_times.stop_id = Stops.stop_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE route_id = ? AND start_time = ?', [_route_id, _start_time])
                    stopseq_model.clear()
                    for (var i = 0;i<rs.rows.length;i++) {
                        if(rs.rows.item(i).stop_id == selections.get(0).stop_id){
                            //console.log(rs.rows.item(i).stop_name)
                            selections.set(0,{"stop_sequence_selected":rs.rows.item(i).stop_sequence})
                        }

                        if (i<selections.get(0).stop_sequence-1){
                            stopseq_model.set(i, {"planned_time":rs.rows.item(i).departure_time.substring(0,5), "stop_name": rs.rows.item(i).stop_name, "stop_sequence":rs.rows.item(i).stop_sequence, "colore":"first"})
                        }
                        else {
                            stopseq_model.set(i, {"planned_time":rs.rows.item(i).departure_time.substring(0,5), "stop_name": rs.rows.item(i).stop_name, "stop_sequence":rs.rows.item(i).stop_sequence, "colore":"second"})
                        }
                    }
                })
}

// load all city data
function load_city_data() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS City(country_name TEXT, country TEXT, city TEXT, cityname TEXT, citynumber TEXT, staticpath TEXT, gtfsversion TEXT, basestring TEXT, urlstring TEXT)');
                    tx.executeSql('DELETE FROM City');
                    for (var i = 0;i<city_xml.count;i++) {
                        tx.executeSql('INSERT INTO City VALUES(?,?,?,?,?,?,?,?,?)', [city_xml.get(i).country_name, city_xml.get(i).country, city_xml.get(i).city,
                                                                                 city_xml.get(i).cityname, city_xml.get(i).citynumber, city_xml.get(i).staticpath,
                                                                                 city_xml.get(i).gtfsversion, city_xml.get(i).basestring, city_xml.get(i).urlstring])
                    }
                })
}

function fill_country() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS City(country_name TEXT, country TEXT, city TEXT, cityname TEXT, citynumber TEXT, staticpath TEXT, gtfsversion TEXT, basestring TEXT, urlstring TEXT)');
                    var rs = tx.executeSql('SELECT DISTINCT country_name, country FROM City')
                    country_list.clear()
                    for (var i = 0;i<rs.rows.length;i++) {
                        country_list.append({"country_name_a":rs.rows.item(i).country_name, "country_a":rs.rows.item(i).country})
                    }
                })
}

function fill_city() {
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS City(country_name TEXT, country TEXT, city TEXT, cityname TEXT, citynumber TEXT, staticpath TEXT, gtfsversion TEXT, basestring TEXT, urlstring TEXT)');
                    var rs = tx.executeSql('SELECT * FROM City WHERE country = ?', [selections.get(0).country])
                    city_list.clear()
                    for (var i = 0;i<rs.rows.length;i++) {
                        city_list.append({"city_a":rs.rows.item(i).city, "cityname_a":rs.rows.item(i).cityname, "citynumber_a":rs.rows.item(i).citynumber, "staticpath_a":rs.rows.item(i).staticpath, "gtfsversion_a":rs.rows.item(i).gtfsversion, "basestring_a":rs.rows.item(i).basestring, "urlstring_a":rs.rows.item(i).urlstring})
                    }
                })
}

function saveSettings() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

                    // country_name
                    var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'country_name');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).country_name, 'country_name'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'country_name', '', selections.get(0).country_name, '', '' ])}

                    // country
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'country');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).country, 'country'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'country', '', selections.get(0).country, '', '' ])}

                    // city
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'city');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).city, 'city'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'city', '', selections.get(0).city, '', '' ])}

                    // cityname
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'cityname');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).cityname, 'cityname'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'cityname', '', selections.get(0).cityname, '', '' ])}

                    // citynumber
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'citynumber');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).citynumber, 'citynumber'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'citynumber', '', selections.get(0).citynumber, '', '' ])}

                    // urlstring
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'urlstring');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).urlstring, 'urlstring'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'urlstring', '', selections.get(0).urlstring, '', '' ])}

                    // staticpath
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'staticpath');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).staticpath, 'staticpath'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'staticpath', '', selections.get(0).staticpath, '', '' ])}

                    // localpath
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'localpath');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).localpath, 'localpath'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'localpath', '', selections.get(0).localpath, '', '' ])}

                    // gtfsversion
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'gtfsversion');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).gtfsversion, 'gtfsversion'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'gtfsversion', '', selections.get(0).gtfsversion, '', '' ])}

                    // basestring
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', 'basestring');
                    if (rs.rows.length > 0) {tx.executeSql('UPDATE Settings SET valte = ? WHERE name = ?', [selections.get(0).basestring, 'basestring'])}
                    // If no players add active player
                    else {tx.executeSql('INSERT INTO Settings VALUES(?, ?, ?, ?, ?)', [ 'basestring', '', selections.get(0).basestring, '', '' ])}
                }
                )

}

function loadSettings() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    // Create the table, if not existing
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(name TEXT, subname TEXT, valte TEXT, valre REAL, valint INTEGER)');

                    // country_name
                    var rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['country_name']);
                    if (rs.rows.length > 0) {selections.set(0,{"country_name": rs.rows.item(0).valte})}
                    else {}

                    // country
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['country']);
                    if (rs.rows.length > 0) {selections.set(0,{"country": rs.rows.item(0).valte})}
                    else {}

                    // city
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['city']);
                    if (rs.rows.length > 0) {selections.set(0,{"city": rs.rows.item(0).valte})}
                    else {}

                    // cityname
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['cityname']);
                    if (rs.rows.length > 0) {selections.set(0,{"cityname": rs.rows.item(0).valte})}
                    else {}

                    // citynumber
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['citynumber']);
                    if (rs.rows.length > 0) {selections.set(0,{"citynumber": rs.rows.item(0).valte})}
                    else {}

                    // urlstring
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['urlstring']);
                    if (rs.rows.length > 0) {selections.set(0,{"urlstring": rs.rows.item(0).valte})}
                    else {}

                    // staticpath
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['staticpath']);
                    if (rs.rows.length > 0) {selections.set(0,{"staticpath": rs.rows.item(0).valte})}
                    else {}

                    // localpath
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['localpath']);
                    if (rs.rows.length > 0) {selections.set(0,{"localpath": rs.rows.item(0).valte})}
                    else {}

                    // gtfsversion
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['gtfsversion']);
                    if (rs.rows.length > 0) {selections.set(0,{"gtfsversion": rs.rows.item(0).valte})}
                    else {}

                    // basestring
                    rs = tx.executeSql('SELECT * FROM Settings WHERE name = ?', ['basestring']);
                    if (rs.rows.length > 0) {selections.set(0,{"basestring": rs.rows.item(0).valte})}
                    else {}
                }

                )

}
