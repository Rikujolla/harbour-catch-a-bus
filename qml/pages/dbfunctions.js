// Function loads the data from XmlListModel busstops_xml
function load_stops() {

    var db = LocalStorage.openDatabaseSync("Catchabus", "1.0", "Catchabus database", 1000000);

    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL)');
                    for (var i=0;i<busstops_xml.count;i++){
                        tx.executeSql('INSERT INTO Stops VALUES(?, ?, ?, ?)', [busstops_xml.get(i).stop_id, busstops_xml.get(i).stop_name, busstops_xml.get(i).stop_lat,
                                                                               busstops_xml.get(i).stop_lon])
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stops(stop_id TEXT, stop_name TEXT, stop_lat REAL, stop_lon REAL)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Stop_times(day TEXT, trip_id TEXT, start_time TEXT, departure_time TEXT, stop_id TEXT, stop_sequence INTEGER)');
                    tx.executeSql('DELETE FROM Stop_times');
                    tx.executeSql('DELETE FROM Stops');
                })
}
