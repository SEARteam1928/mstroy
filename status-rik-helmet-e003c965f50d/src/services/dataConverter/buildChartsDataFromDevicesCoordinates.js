import parse from '@services/utils/dateUtils/parse';
import startOfDay from '@services/utils/dateUtils/startOfDay';
import endOfDay from '@services/utils/dateUtils/endOfDay';

const buildChartsDataFromDevicesCoordinates = devicesCoordinates => {
    let chartsData = {
        activity: [],
        battery: []
    };

    if (!(devicesCoordinates instanceof Array)) return chartsData;

    devicesCoordinates.forEach(({ activityLevel, batteryInPercents, createdAt }) => {
        let date = parse(createdAt);
        let _activity = { date, value: activityLevel };

        let batteryValue = parseFloat(batteryInPercents).toFixed(0);
        let _battery = { date, value: batteryValue };

        chartsData.activity.push(_activity);
        chartsData.battery.push(_battery);
    });

    return chartsData;
};

export default buildChartsDataFromDevicesCoordinates;
