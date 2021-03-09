// Function calculates the distance of a bus from your position
function distance(thelati, thelongi) {

    // Spherical distance
    var dfii; // Latitude difference
    var meanfii; // Latitude difference mean
    var dlamda; // Longitude difference
    var ddist; // Distance in meters
    var coord = possut.position.coordinate

    dfii = Math.abs(coord.latitude - thelati)*Math.PI/180;
    meanfii = (coord.latitude + thelati)*Math.PI/360
    dlamda = Math.abs(coord.longitude - thelongi)*Math.PI/180;
    ddist = Math.round(6371009*Math.sqrt(Math.pow(dfii,2)+Math.pow(Math.cos(meanfii)*dlamda,2)));

    //console.log("Latitude, longitude, dist", thelati, thelongi, ddist, possut.sourceError);
    return ddist;

}
/*
function closest_stop() {
    var dist_smallest = 400000.0
    var dist_temp = 400000;
    var _thelati = 0.0
    var _thelongi = 0.0
    var _selected = 0;
    for (var i=0;i<busstops_xml.count;i++){
        _thelati = (busstops_xml.get(i).stop_lat)
        _thelongi = (busstops_xml.get(i).stop_lon)
        //console.log(_thelati, _thelongi, _thelati+_thelongi)
        dist_temp = distance(_thelati, _thelongi)
        if (dist_temp < dist_smallest){
            dist_smallest = dist_temp
            _selected = i;
        }
    }
    console.log ("Pysakille " + busstops_xml.get(_selected).stop_name + " " + dist_smallest + "m" )
    selected_stop.text = busstops_xml.get(_selected).stop_name + ", " + dist_smallest + "m"
    selected_busstop.clear();
    selected_busstop.set(0,{"stop_id":busstops_xml.get(_selected).stop_id, "stop_name":busstops_xml.get(_selected).stop_name})
}
*/
function get_time() {
    var d = new Date();
    var n = d.toLocaleTimeString();

    switch(d.getDay()) {
      case 0:
        day = "S"
        break;
      case 6:
          day = "L"
        break;
      default:
          day = "M-P"
    }
    console.log(day)

    if(n.substr(2,1) == "."){
        current_time = n.substr(0,2) + ":" + n.substr(3,2) + ":" + n.substr(6, 2)
    }
    else {
        current_time = "0" + n.substr(0,1) + ":" + n.substr(2,2) + ":" + n.substr(5, 2)
    }
    //console.log(n, n.substr(0, 2),n.substr(3, 2),n.substr(6, 2) )
}
