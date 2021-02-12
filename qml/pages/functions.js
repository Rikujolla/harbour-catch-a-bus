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
    ddist = 6371009*Math.sqrt(Math.pow(dfii,2)+Math.pow(Math.cos(meanfii)*dlamda,2));

    console.log("ddist ", ddist);
    return ddist;

}
