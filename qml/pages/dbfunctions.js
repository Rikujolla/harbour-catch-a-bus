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

function get_stop_name(_name) {

    var rs
    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    rs = tx.executeSql('SELECT * FROM Stops WHERE stop_id = ?', [_name]);
                })
    return rs.rows.item(0).stop_name
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
                    /*console.log("hhhhh trips",calendar_xml.get(0).service_id, calendar_xml.get(0).monday, calendar_xml.get(0).tuesday
                                , calendar_xml.get(0).wednesday, calendar_xml.get(0).thursday, calendar_xml.get(0).friday
                                , calendar_xml.get(0).saturday, calendar_xml.get(0).sunday, calendar_xml.get(0).start_date
                                , calendar_xml.get(0).end_date)*/
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
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
                    /*
                    //_dateday = "20210501"
                    // Check services with dates
                    tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND friday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                    //var rt = tx.executeSql('SELECT service_id, sum(exception_type) AS  exception_type FROM Calendar_tmp GROUP BY service_id')
                    var rt = tx.executeSql('SELECT * FROM Calendar_tmp')
                    for (var j=0;j<rt.rows.length;j++) {
                        console.log("one", rt.rows.item(j).service_id, rt.rows.item(j).exception_type)
                    }
                    // With average erraneous data can be handled that is if vthe service is ordered twice
                    tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                    console.log("vali")
                    rt = tx.executeSql('SELECT * FROM Calendar_tmp2')
                    for (j=0;j<rt.rows.length;j++) {
                        console.log("two", rt.rows.item(j).service_id, rt.rows.item(j).exception_type)
                    }
                    tx.executeSql('DELETE FROM Calendar_tmp');
                    tx.executeSql('DELETE FROM Calendar_tmp2');
                    */

                    if (_d.getDay() == 0) {
                        console.log("day", day, _d.getDay())
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND sunday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        var rs = tx.executeSql('SELECT day, start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 1) {
                        console.log("day", day, _d.getDay())
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND monday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT day, start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 2) {
                        console.log("day", day, _d.getDay())
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND tuesday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT day, start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 3) {
                        console.log("day", day, _d.getDay())
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND wednesday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT day, start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 4) {
                        console.log("day", day, _d.getDay())
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND thursday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT day, start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 5) {
                        console.log("day", day, _d.getDay())
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND friday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT day, start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else if (_d.getDay() == 6) {
                        console.log("day", day, _d.getDay())
                        // First selecting service_ids from normal calendar
                        tx.executeSql('INSERT INTO Calendar_tmp SELECT service_id, ? AS exception_type FROM Calendar WHERE start_date <= ? AND end_date >=? AND saturday = ? UNION SELECT service_id, exception_type FROM Calendar_dates WHERE date = ?', ["1", _dateday, _dateday, "1", _dateday])
                        // Then checking the effect of exceptions
                        tx.executeSql('INSERT INTO Calendar_tmp2 SELECT service_id, avg(exception_type) FROM Calendar_tmp GROUP BY service_id HAVING avg(exception_type)==1.0')
                        // Then loading routes on the stop on the selected day,
                        rs = tx.executeSql('SELECT day, start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar_tmp2 ON Calendar_tmp2.service_id = Trips.service_id WHERE stop_id = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id]);
                    }
                    else {
                        console.log("some error, day", day, _d.getDay())
                        //rs = tx.executeSql('SELECT day, start_time, departure_time, stop_id, route_short_name, route_long_name, Trips.route_id AS route_id, monday FROM Stop_times INNER JOIN Trips ON Stop_times.trip_id=Trips.trip_id INNER JOIN Routes ON Trips.route_id=Routes.route_id INNER JOIN Calendar ON Calendar.service_id = Trips.service_id WHERE stop_id = ? and monday = ? ORDER BY start_time ASC', [selected_busstop.get(stop_index).stop_id, "1"]);
                    }
                    bus_at_stop.clear()
                    //console.log(selected_busstop.get(stop_index).stop_id, rs.rows.length)

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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    //var rs = tx.executeSql('SELECT *, (ABS(stop_lat-?) + ABS(stop_lon-?)) AS mydist FROM Stops GROUP BY stop_id ORDER BY mydist ASC LIMIT 20', [possut.position.coordinate.latitude, possut.position.coordinate.longitude]);
                    var rs = tx.executeSql('SELECT * FROM Stops');
                    var dist_temp = 400000;
                    var _thelati = 0.0
                    var _thelongi = 0.0
                    var coord = possut.position.coordinate

                    for (var i=0;i<rs.rows.length;i++){
                        _thelati = (rs.rows.item(i).stop_lat)
                        _thelongi = (rs.rows.item(i).stop_lon)
                        dist_temp = Myfunc.distance(_thelati, _thelongi,coord.latitude, coord.longitude)
                        tx.executeSql('UPDATE Stops SET mydistance = ?  WHERE stop_id = ?', [dist_temp,rs.rows.item(i).stop_id])
                    }

                    rs = tx.executeSql('SELECT * FROM Stops WHERE mydistance < ? ORDER BY mydistance ASC', [2000]);
                    selected_busstop.clear();
                    for (i=0;i<rs.rows.length;i++){
                        selected_busstop.set(i,{"stop_id":rs.rows.item(i).stop_id, "stop_name":rs.rows.item(i).stop_name, "dist_me":rs.rows.item(i).mydistance, "stop_lat":rs.rows.item(i).stop_lat, "stop_lon":rs.rows.item(i).stop_lon})
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Routes(route_id TEXT, route_short_name TEXT, route_long_name TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Trips(route_id TEXT, service_id TEXT, trip_id TEXT)');
                    if (selections.get(0).stop_name != 'Not selected'){
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL, mydistance REAL, busdistance REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Busses(route_id TEXT, start_time TEXT, label TEXT, license_plate TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Routes(route_id TEXT, route_short_name TEXT, route_long_name TEXT)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Trips(route_id TEXT, service_id TEXT, trip_id TEXT)');
                    var rs = tx.executeSql('SELECT *, stop_name, route_id FROM Stop_times INNER JOIN Trips ON Trips.trip_id=Stop_times.trip_id INNER JOIN Stops ON Stop_times.stop_id = Stops.stop_id WHERE day = ? AND route_id = ? AND start_time = ?', [_day, _route_id, _start_time])
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

                    //console.log(_day, _trip_id, _start_time)
                })
}
