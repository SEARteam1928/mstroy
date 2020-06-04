export const historySize = state => state.historySize;

export const mobileMode = state => state.mobileMode;

export const deviceList = state => state.deviceList;
export const deviceListMap = state => state.deviceListMap;
export const getDevice = state => id => state.deviceList[state.deviceListMap[id]];

export const deviceFilters = state => state.deviceFilters;
export const deviceListWithFilters = state => {
    let devices = state.deviceList;

    state.deviceFilters.forEach(({ filter }) => {
        devices = filter(devices);
    });

    return devices;
};

export const editModalOpen = state => state.editModalOpen;
export const editModalData = state => state.editModalData;
export const editModalReady = state => {
    let ready = false;
    let { name, loraKey, assetsNumber } = state.editModalData;

    if (name && loraKey && assetsNumber !== null) ready = true;

    return ready;
};

export const deleteModalOpen = state => state.deleteModalOpen;
export const deleteModalData = state => state.deleteModalData;

export const dataModalOpen = state => state.dataModalOpen;
export const dataModalData = state => state.dataModalData;

export const creatingDevice = state => state.creatingDevice;

export const autoUpdate = state => state.autoUpdate;

// Для обработки ошибок
export const moduleErrors = state => {
    let errors = {};
    Object.keys(state.moduleErrors).forEach(err => {
        let error = state.moduleErrors[err];
        if (error) errors[err] = error;
    });

    return errors;
};
export const showErrors = (state, getters) => {
    return JSON.stringify(getters.moduleErrors, ' ', 4);
};
