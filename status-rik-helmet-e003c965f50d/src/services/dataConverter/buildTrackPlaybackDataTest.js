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

    // console.log('-buildTrackPlaybackDataTest-:', prop);

    if (!Object.keys(prop.devices).length || !prop.deviceCoordinates.length) {
        return [];
    }

    let tracksDataMap = {};
    let tracksDataArr = [];

    prop.deviceCoordinates.forEach(coord => {
        let name = prop.devices[coord.dev].Name;
        let lat = coord.LatitudeGPS || coord.LatitudeBLE;
        let lng = coord.LongtitudeGPS || coord.LongtitudeBLE;
        let time = Date.parse(coord.TimeStamp) / 1000;
        if (!lat || !lng || !time) return;

        let nameIndex = tracksDataMap[name];
        if (nameIndex === undefined) {
            nameIndex = tracksDataArr.length;
            tracksDataMap[name] = nameIndex;

            tracksDataArr.push([]);
        }

        let pointData = {
            lat,
            lng,
            time,
            info: [
                {
                    key: 'name',
                    value: name
                }
            ]
        };

        if (prop.alt) {
            let alt = prop.altMethod(coord[prop.altProp]);
            pointData.alt = alt;

            pointData.info.push({
                key: prop.altProp,
                value: alt
            });
        }

        tracksDataArr[nameIndex].push(pointData);
    });

    return tracksDataArr;
};
