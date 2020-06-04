export default {
    historySize: 50,

    mobileMode: false,

    deviceList: [],
    deviceListMap: {},

    deviceFilters: [],

    editModalOpen: false,
    editModalData: {
        id: null,
        name: null,
        loraKey: null,
        assetsNumber: null,
        sendPeriod: 300,
        ethalon: false
    },

    deleteModalOpen: false,
    deleteModalData: {
        id: null
    },

    dataModalOpen: false,
    dataModalData: {
        id: null
    },

    creatingDevice: false,

    autoUpdate: false,

    moduleErrors: {
        requestDeviceList: false,
        requestCreateDevice: false,
        requestDeleteDevice: false,
        requestEditDevice: false
    }
};
