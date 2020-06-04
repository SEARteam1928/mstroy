export default {
    periodDate: {
        from: null,
        to: null
    },

    deviceList: [],
    deviceListMap: {},

    selectedDevicesId: [],

    deviceCoordinates: [],

    isActiveRequestDeviceList: false,
    isActiveRequestDeviceCoordinates: false,
    isActiveRequestDeviceCoordinatesExcel: false,

    moduleErrors: {
        requestDeviceList: false,
        requestDeviceCoordinates: false,
        requestDeviceCoordinatesExcel: false
    }
};
