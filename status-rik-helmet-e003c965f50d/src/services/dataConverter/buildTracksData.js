export default (devices, deviceCoordinates) => {
    let tracksDataMap = {};
    let tracksDataArr = [];

    deviceCoordinates.forEach(coord => {
        let name = devices[coord.dev].Name;
        let lat = coord.LatitudeGPS || coord.LatitudeBLE;
        let lng = coord.LongtitudeGPS || coord.LongtitudeBLE;
        let alt = coord.Altitude || coord.AltitudeGPS || coord.AltitudeBLE;
        let time = Date.parse(coord.TimeStamp);
        if (!lat || !lng || !time) return;

        let nameIndex = tracksDataMap[name];
        if (nameIndex === undefined) {
            nameIndex = tracksDataArr.length;
            tracksDataMap[name] = nameIndex;

            tracksDataArr.push({
                type: 'Feature',
                geometry: {
                    type: 'MultiPoint',
                    coordinates: []
                },
                properties: {
                    time: [],
                    altitude: []
                    // name
                }
            });

            // tracksDataArr.push(
            //     Object.create(null, {
            //         type: { writable: true, configurable: true, value: 'Feature' },
            //         geometry: {
            //             writable: true,
            //             configurable: true,
            //             value: Object.create(null, {
            //                 type: { writable: true, configurable: true, value: 'MultiPoint' },
            //                 coordinates: { writable: true, configurable: true, value: [] }
            //             })
            //         },
            //         properties: {
            //             writable: true,
            //             configurable: true,
            //             value: Object.create(null, {
            //                 time: { writable: true, configurable: true, value: [] }
            //                 // altitude: { writable: true, configurable: true, value: [] }
            //             })
            //         }
            //     })
            // );
        }

        tracksDataArr[nameIndex].geometry.coordinates.push([lng, lat]);
        tracksDataArr[nameIndex].properties.time.push(time);
        // tracksDataArr[nameIndex].properties.altitude.push(alt);
    });

    // tracksData[name] = {
    //     type: 'Feature',
    //     geometry: {
    //         type: 'MultiPoint',
    //         coordinates: []
    //     },
    //     properties: {
    //         time: [],
    //         altitude: []
    //         // name
    //     }
    // };

    tracksDataArr.forEach(tracksData => {
        Object.freeze(tracksData);
    });

    return tracksDataArr;
};
