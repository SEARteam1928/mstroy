export const periodDate = state => state.periodDate;

export const deviceList = state => state.deviceList;
export const deviceListMap = state => state.deviceListMap;
export const getDevice = state => id => state.deviceList[state.deviceListMap[id]];

export const selectedDevicesId = state => state.selectedDevicesId;
export const selectedDevices = state => {
    let selectedDevices = state.selectedDevicesId.map(id => {
        let index = state.deviceListMap[id];
        let device = state.deviceList[index];

        return device;
    });

    return selectedDevices;
};

export const deviceCoordinates = state => state.deviceCoordinates;

export const isActiveRequestDeviceList = state => state.isActiveRequestDeviceList;
export const isActiveRequestDeviceCoordinates = state => state.isActiveRequestDeviceCoordinates;
export const isActiveRequestDeviceCoordinatesExcel = state => state.isActiveRequestDeviceCoordinatesExcel;

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
