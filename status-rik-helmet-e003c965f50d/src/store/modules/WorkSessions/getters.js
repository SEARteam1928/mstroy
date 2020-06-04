export const projectId = state => state.projectId;

// Получение списка устройств
export const devices = state => state.devices;
// Карта для получения устройства по его id
export const devicesMap = state => state.devicesMap;
// Получение устройства по его id
export const device = state => id => state.devicesMap[id];

// Получение списка работников
export const workersData = state => state.workersData;
// Получение одного работника по его id
export const workerData = state => id => state.workersMap[id];

// Получение списка рабочих сессий
export const workSessionsData = state => state.workSessionsData;
export const workSessionsDataById = state => deviceId => state.workSessionsData[deviceId] || [];

// Получение списка time_resource данных
export const timeResourceData = state => state.timeResourceData;
// Получение одного time_resource по его id
export const timeResource = state => id => state.timeResourceData[state.timeResourceMap[id]];

// Данные для таблицы
export const compiledTableData = state => state.compiledTableData;

export const selectedPeriod = state => state.selectedPeriod;

export const selectedDevice = state => state.selectedDevice;

export const editModalOpen = state => state.editModalOpen;
export const deleteModalOpen = state => state.deleteModalOpen;

export const deleteModalData = state => state.deleteModalData;

// Получение данных для создания новой сессии
export const editModalData = state => state.editModalData;
export const editModalDataReady = state => {
    let { device_id, time_resource_id, start_date, finish_date } = state.editModalData;
    if (device_id === null || time_resource_id === null || start_date === null) {
        return false;
    }

    return true;
};

// Получение списка доступных работников на проекте
export const availableWorkers = (state, getters) => {
    let result = [];

    state.timeResourceData.forEach(timeRes => {
        let { id, worker_id } = timeRes;
        let workerData = getters.workerData(worker_id);
        if (!workerData) return;

        let { last_name, first_name, surname } = workerData;
        let worker = {
            id,
            worker_id,
            name: `${last_name} ${first_name} ${surname}`
        };

        result.push(worker);
    });

    return result;
};

// Получение флага отправки запроса для создания новой сессии
export const sessionProcessing = state => state.sessionProcessing;

// Флаг, отмечающий, доступны ли все данные, необходимые для отображения таблицы рабочих сессий
export const dataIsAvailable = (state, getters) => {
    let result = true;
    let { devices, workersData, timeResourceData } = getters;

    if (!devices.length || !workersData.length || !timeResourceData.length) {
        result = false;
    }

    return result;
};

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
