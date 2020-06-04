import { date as quasarDate } from 'quasar';

export default prop => {
    let defaultProp = {
        devices: {},
        deviceCoordinates: [],
        alt: false,
        altProp: 'ActivityLevel',
        altMethod: alt => alt
    };

    prop = {
        ...defaultProp,
        ...prop
    };

    if (!Object.keys(prop.devices).length || !prop.deviceCoordinates.length) {
        return [];
    }

    let tracksDataMap = {};
    let tracksDataArr = [];
    let dateMask = 'DD.MM.YYYY HH:mm:ss';

    prop.deviceCoordinates.forEach(coord => {
        // debugger;
        let name = prop.devices[coord.dev].Name || prop.devices[coord.dev].name;
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
                    key: 'Имя',
                    value: name
                },
                {
                    key: 'Время',
                    value: quasarDate.formatDate(coord.TimeStamp, dateMask)
                }
            ]
        };

        // if()

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
