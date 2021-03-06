export default prop => {
    let defaultProp = {
        devices: null,
        deviceCoordinates: 'testRealData',
        alt: false,
        altProp: 'ActivityLevel',
        altMethod: alt => alt
    };

    prop = {
        ...defaultProp,
        ...prop
    };

    prop.devices = require('./testDevices.json');
    prop.deviceCoordinates = require(`./${prop.deviceCoordinates}.json`);

    // console.log('-buildLatLngArrTest-:', prop);

    let latLngArr = [];

    prop.deviceCoordinates.forEach(coord => {
        let lat = coord.LatitudeGPS || coord.LatitudeBLE;
        let lng = coord.LongtitudeGPS || coord.LongtitudeBLE;

        if (!lat || !lng) return;

        if (prop.alt) {
            let alt = prop.altMethod(coord[prop.altProp]);
            latLngArr.push(L.latLng(lat, lng, alt));
        } else {
            latLngArr.push(L.latLng(lat, lng));
        }
    });

    return latLngArr;
};
