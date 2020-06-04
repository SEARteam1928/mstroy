export default {
    isActiveRequestAllDevices: false,
    allDevices: [],
    allDevicesMap: {},
    historySize: 1,
    selectedDevicesId: [],

    deviceFilters: [],
    allDevicesRequestTimestamp: null,

    isActiveRequestAllTimeResources: false,
    allTimeResources: [],
    allTimeResourcesMap: {},

    // Данные для создания новой сессии
    editSessionModalData: {
        id: null,
        deviceId: null,
        timeResourceId: null,
        startDate: null,
        finishDate: null
    },
    editSessionModalOpen: false,

    deleteSessionModalData: {
        id: null
    },
    deleteSessionModalOpen: false,

    sessionProcessing: false,

    waitDeviceScannerSignal: false,
    waitConfirmChangeRfid: false,
    waitConfirmDeleteRfid: false,
    newRfid: null,

    deviceProcession: false,

    giveDeviceModalData: {
        scannedRfid: null,
        deviceId: null,
        lastSessions: [],
        editLastSession: false,
        timeResourceId: null,
        startDate: null,
        finishDate: null,
        deviceNotFound: false
    },
    giveDeviceModalOpen: false,

    moduleErrors: {
        requestAllDevices: false,
        requestAllTimeResources: false,
        requestCreateSession: false,
        requestUpdateSession: false,
        requestDeleteSession: false,
        requestEditDevice: false,
        requestAllWorkSessions: false,
        requestDeviceCoordinates: false
    }
};
