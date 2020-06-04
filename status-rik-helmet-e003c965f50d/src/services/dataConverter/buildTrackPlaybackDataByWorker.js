import { date as quasarDate } from 'quasar';

export default prop => {
    let defaultProp = {
        workerName: '',
        deviceCoordinates: [],
        alt: false,
        altProp: 'ActivityLevel',
        altMethod: alt => alt
    };

    prop = {
        ...defaultProp,
        ...prop
    };

    if (!prop.workerName || !prop.deviceCoordinates.length) {
        return [];
    }

    let tracksDataArr = [[]];
    let dateMask = 'DD.MM.YYYY HH:mm:ss';

    prop.deviceCoordinates.forEach(coord => {
        let lat = coord.LatitudeGPS || coord.LatitudeBLE;
        let lng = coord.LongtitudeGPS || coord.LongtitudeBLE;
        let time = Date.parse(coord.TimeStamp) / 1000;
        if (!lat || !lng || !time) return;

        let pointData = {
            lat,
            lng,
            time,
            info: [
                {
                    key: 'Имя',
                    value: prop.workerName
                },
                {
                    key: 'Время',
                    value: quasarDate.formatDate(coord.TimeStamp, dateMask)
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

        tracksDataArr[0].push(pointData);
    });

    return tracksDataArr;
};
