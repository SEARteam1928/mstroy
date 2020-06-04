import isFalse from '@services/utils/isFalse';

export const setAllDevices = (state, allDevices) => (state.allDevices = allDevices);
export const clearAllDevices = state => (state.allDevices = []);
export const setAllDevicesMap = (state, allDevicesMap) => (state.allDevicesMap = allDevicesMap);
export const clearAllDevicesMap = state => (state.allDevicesMap = {});
export const setHistorySize = (state, historySize) => (state.historySize = historySize);
export const setIsActiveRequestAllDevices = (state, isActive) => (state.isActiveRequestAllDevices = isActive);
export const setAllDevicesRequestTimestamp = (state, timestamp) => (state.allDevicesRequestTimestamp = timestamp);

export const setSelectedDevicesId = (state, devicesId) => {
    if (!(devicesId instanceof Array)) devicesId = [devicesId];

    state.selectedDevicesId = devicesId;
};
export const addSelectedDevicesId = (state, devicesId) => {
    if (!(devicesId instanceof Array)) devicesId = [devicesId];

    let selectedDevicesIdSet = new Set(state.selectedDevicesId);
    devicesId.forEach(id => selectedDevicesIdSet.add(id));

    state.selectedDevicesId = [...selectedDevicesIdSet.values()];
};

export const removeSelectedDevicesId = (state, devicesId) => {
    if (!(devicesId instanceof Array)) devicesId = [devicesId];

    let selectedDevicesIdSet = new Set(state.selectedDevicesId);
    devicesId.forEach(id => selectedDevicesIdSet.delete(id));

    state.selectedDevicesId = [...selectedDevicesIdSet.values()];
};

export const toggleSelectedDevicesId = (state, devicesId) => {
    if (!(devicesId instanceof Array)) devicesId = [devicesId];

    let selectedDevicesIdSet = new Set(state.selectedDevicesId);
    devicesId.forEach(id => {
        selectedDevicesIdSet.has(id) ? selectedDevicesIdSet.delete(id) : selectedDevicesIdSet.add(id);
    });

    state.selectedDevicesId = [...selectedDevicesIdSet.values()];
};

export const selectAllSelectedDevicesId = state => {
    state.selectedDevicesId = state.allDevices.map(({ id }) => id);
};

export const removeAllSelectedDevicesId = state => (state.selectedDevicesId = []);

export const setDeviceFilters = (state, filters) => (state.deviceFilters = filters);

export const setIsActiveRequestAllTimeResources = (state, isActive) =>
    (state.isActiveRequestAllTimeResources = isActive);
export const setAllTimeResources = (state, allTimeResources) => (state.allTimeResources = allTimeResources);
export const setAllTimeResourcesMap = (state, allTimeResourcesMap) => (state.allTimeResourcesMap = allTimeResourcesMap);
export const clearAllTimeResources = state => (state.allTimeResources = []);
export const clearAllTimeResourcesMap = (state, {}) => (state.allTimeResourcesMap = {});
export const setEditSessionModalData = (state, data) => {
    state.editSessionModalData = {
        ...state.editSessionModalData,
        ...data
    };
};
export const clearEditSessionModalData = state => {
    state.editSessionModalData = {
        id: null,
        deviceId: null,
        timeResourceId: null,
        startDate: null,
        finishDate: null
    };
};
export const setEditSessionModalOpen = (state, isOpen) => (state.editSessionModalOpen = isOpen);

export const setDeleteSessionModalData = (state, data) => {
    state.deleteSessionModalData = {
        ...state.deleteSessionModalData,
        ...data
    };
};
export const clearDeleteSessionModalData = state => (state.deleteSessionModalData = { id: null });
export const setDeleteSessionModalOpen = (state, isOpen) => (state.deleteSessionModalOpen = isOpen);

// Устанавливает флаг на время отправки запроса для создания новой сессии
export const setSessionProcessing = (state, flag) => (state.sessionProcessing = flag);

export const setWaitDeviceScannerSignal = (state, flag) => (state.waitDeviceScannerSignal = flag);
export const setWaitConfirmChangeRfid = (state, flag) => (state.waitConfirmChangeRfid = flag);
export const setWaitConfirmDeleteRfid = (state, flag) => (state.waitConfirmDeleteRfid = flag);
export const setNewRfid = (state, newRfid) => (state.newRfid = newRfid);

export const setDeviceProcession = (state, flag) => (state.deviceProcession = flag);

export const updateLocalDeviceData = (state, deviceData) => {
    let index = state.allDevicesMap[deviceData.id];
    if (isFalse(index)) return;

    let oldDeviceData = state.allDevices[index];
    state.allDevices.splice(index, 1, {
        ...oldDeviceData,
        ...deviceData
    });
};

export const setGiveDeviceModalData = (state, modalData) => {
    state.giveDeviceModalData = {
        ...state.giveDeviceModalData,
        ...modalData
    };
};
export const clearGiveDeviceModalData = state => {
    state.giveDeviceModalData = {
        scannedRfid: null,
        selectedDeviceId: null,
        lastSessions: [],
        editLastSession: false,
        timeResourceId: null,
        startDate: null,
        finishDate: null,
        deviceNotFound: false
    };
};
export const setGiveDeviceModalOpen = (state, flag) => (state.giveDeviceModalOpen = flag);
