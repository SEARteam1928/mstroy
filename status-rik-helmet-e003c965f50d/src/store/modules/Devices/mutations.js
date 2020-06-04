// commit
export const setHistorySize = (state, size) => (state.historySize = size);

export const setMobileMode = (state, mode) => (state.mobileMode = mode);

// Работа со списками устройств
export const setDeviceList = (state, deviceList) => (state.deviceList = deviceList);
export const clearDeviceList = state => (state.deviceList = []);
export const setDeviceListMap = (state, map) => (state.deviceListMap = map);
export const clearDeviceListMap = state => (state.deviceListMap = {});

export const setDeviceFilters = (state, filters) => (state.deviceFilters = filters);

// Добавление/обновление/удаление по одному определенному устройству
export const addOneDeviceMap = (state, { index, id }) => {
    state.deviceListMap = {
        ...state.deviceListMap,
        [id]: index
    };
};
export const addOneDevice = (state, device) => state.deviceList.push(device);
export const updateOneDevice = (state, { id, name, loraKey }) => {
    let index = state.deviceListMap[id];
    if (index === undefined) return;

    let device = {
        ...state.deviceList[index],
        name,
        assetsNumber: Number(name),
        lora_key: loraKey
    };

    state.deviceList.splice(index, 1, device);
};
export const deleteOneDevice = (state, id) => {
    let index = state.deviceListMap[id];
    if (index === undefined) return;

    state.deviceList.splice(index, 1);
    delete state.deviceListMap[id];
};

// Работа с модалками
export const setEditModalOpen = (state, isOpen) => (state.editModalOpen = isOpen);
export const setEditModalData = (state, data) => {
    state.editModalData = {
        ...state.editModalData,
        ...data
    };
};
export const clearEditModalData = state => {
    state.editModalData = {
        id: null,
        name: null,
        loraKey: null,
        assetsNumber: null,
        sendPeriod: 300,
        ethalon: false
    };
};

export const setDeleteModalOpen = (state, isOpen) => (state.deleteModalOpen = isOpen);
export const setDeleteModalData = (state, data) => {
    state.deleteModalData = {
        ...state.deleteModalData,
        ...data
    };
};
export const clearDeleteModalData = state => (state.deleteModalData = { id: null });

export const setDataModalOpen = (state, isOpen) => (state.dataModalOpen = isOpen);
export const setDataModalData = (state, data) => (state.dataModalData = data);
export const clearDataModalData = state => (state.dataModalData = {});

export const setCreatingDevice = (state, creatingDevice) => (state.creatingDevice = creatingDevice);

export const setAutoUpdate = (state, autoUpdate) => (state.autoUpdate = autoUpdate);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
