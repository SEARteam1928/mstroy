export const setPeriodDate = (state, periodDate) => {
    state.periodDate = {
        ...state.periodDate,
        ...periodDate
    };
};

// Работа со списками устройств
export const setDeviceList = (state, deviceList) => (state.deviceList = deviceList);
export const clearDeviceList = state => (state.deviceList = []);
export const setDeviceListMap = (state, map) => (state.deviceListMap = map);
export const clearDeviceListMap = state => (state.deviceListMap = {});

export const setSelectedDevicesId = (state, devicesId) => (state.selectedDevicesId = devicesId);
export const clearSelectedDevicesId = state => (state.selectedDevicesId = []);

export const setDeviceCoordinates = (state, deviceCoordinates) => (state.deviceCoordinates = deviceCoordinates);
export const clearDeviceCoordinates = state => (state.deviceCoordinates = []);

export const setIsActiveRequestDeviceList = (state, active) => (state.isActiveRequestDeviceList = active);
export const setIsActiveRequestDeviceCoordinates = (state, active) => (state.isActiveRequestDeviceCoordinates = active);
export const setIsActiveRequestDeviceCoordinatesExcel = (state, active) =>
    (state.isActiveRequestDeviceCoordinatesExcel = active);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
