import Vue from 'vue';

// commit
export const setProjectId = (state, id) => (state.projectId = id);

// Данные устройств
export const setDevices = (state, devices) => (state.devices = devices);
export const clearDevices = state => (state.devices = []);
// Карта для получения устройства по его id
export const setDevicesMap = (state, devicesMap) => (state.devicesMap = devicesMap);
export const clearDevicesMap = state => (state.devicesMap = {});

// Данные работников
export const setWorkersData = (state, workersData) => (state.workersData = workersData);
export const clearWorkersData = state => (state.workersData = []);
export const setWorkersMap = (state, workersMap) => (state.workersMap = workersMap);
export const clearWorkersMap = state => (state.workersMap = {});

// Данные рабочих сессий
export const setWorkSessionsData = (state, { deviceId, data }) => {
    let workSessionsData = {
        ...state.workSessionsData,
        [deviceId]: data
    };

    Vue.set(state, 'workSessionsData', workSessionsData);
};

export const clearWorkSessionsData = (state, deviceId) => {
    let workSessionsData = {};

    if (deviceId !== undefined) {
        workSessionsData = {
            ...state.workSessionsData,
            [deviceId]: []
        };
    }

    Vue.set(state, 'workSessionsData', workSessionsData);
};

// Данные time_resource
export const setTimeResourceData = (state, timeResourceData) => (state.timeResourceData = timeResourceData);
export const clearTimeResourceData = state => (state.timeResourceData = []);

export const setTimeResourceMap = (state, timeResourceMap) => (state.timeResourceMap = timeResourceMap);
export const clearTimeResourceMap = state => (state.timeResourceMap = {});

// Выбранное устройство
export const setSelectedDevice = (state, device) => (state.selectedDevice = device);
export const clearSelectedDevice = state => (state.selectedDevice = null);

// Выбранный период для отображения данных
export const setSelectedPeriod = (state, period) => (state.selectedPeriod = { ...state.selectedPeriod, ...period });
export const clearSelectedPeriod = state => (state.selectedPeriod = { from: null, to: null });

export const setEditModalOpen = (state, editModalOpen = false) => (state.editModalOpen = editModalOpen);
export const setDeleteModalOpen = (state, deleteModalOpen = false) => (state.deleteModalOpen = deleteModalOpen);

// Данные для удаления сессии
export const setDeleteModalData = (state, deleteModalData) =>
    (state.deleteModalData = {
        ...state.deleteModalData,
        ...deleteModalData
    });
export const clearDeleteModalData = state =>
    (state.deleteModalData = {
        work_session_id: null,
        device_id: null
    });

// Данные для создания новой сессии
export const setEditModalData = (state, editModalData) => {
    state.editModalData = {
        ...state.editModalData,
        ...editModalData
    };
};
export const clearEditModalData = state => {
    state.editModalData = {
        work_session_id: null,
        device_id: null,
        time_resource_id: null,
        start_date: null,
        finish_date: null
    };
};

// Устанавливает флаг на время отправки запроса для создания новой сессии
export const setSessionProcessing = (state, flag) => (state.sessionProcessing = flag);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
