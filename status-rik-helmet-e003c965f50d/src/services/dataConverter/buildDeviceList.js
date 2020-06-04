import { uid } from 'quasar';

export default apiData => {
    let deviceList = [];
    let deviceMap = {};
    let requestTimestamp = new Date();

    apiData.forEach(deviceData => {
        let { id, lora_key, name, coords, current_worker, ethalon, send_period, rfid_value: rfidValue } = deviceData;
        let index = deviceList.length;
        deviceMap[id] = index;

        let owner = {
            first_name: current_worker.first_name || null,
            id: current_worker.id || null,
            last_name: current_worker.last_name || null,
            surname: current_worker.surname || null
        };

        let device = {
            id,
            lora_key,
            name,
            owner,
            ethalon,
            send_period,
            rfidValue,
            connectTime: null,
            currentZone: {},
            currentSession: null,
            dates: [],
            activityLevel: [],
            battery: [],
            temperature: [],
            altitude: [],
            uid: uid(),
            rawData: deviceData,
            requestTimestamp
        };

        coords.forEach((coord, idx) => {
            let { created_at, activityLevel, battery, temperature, altitude, object_id, object_name } = coord;

            // Берем последнюю запись, в которой должна быть актуальная информация
            if (idx === coords.length - 1) {
                device.connectTime = created_at;
                device.currentZone = { object_id, object_name };
            }

            let date = new Date(created_at);

            device.dates.push(created_at);

            device.activityLevel.push({
                date,
                value: Number(activityLevel)
            });
            device.battery.push({
                date,
                value: Math.round(Number(battery))
            });
            device.temperature.push({
                date,
                value: Math.round(Number(temperature))
            });
            device.altitude.push({
                date,
                value: Number(altitude)
            });
        });

        deviceList.push(device);
    });

    // deviceList.sort((a, b) => {
    //     let numberNameA = parseInt(a.name);
    //     let numberNameB = parseInt(b.name);
    //     if (isNaN(numberNameA) || isNaN(numberNameB)) return a.name > b.name ? 1 : -1;

    //     return numberNameA > numberNameB ? 1 : -1;
    // });

    // deviceList.forEach(({ id }, index) => {
    //     deviceMap[id] = index;
    // });

    return {
        deviceList,
        deviceMap
    };
};
