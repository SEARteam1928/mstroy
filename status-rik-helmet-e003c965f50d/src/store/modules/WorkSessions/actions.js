import Api from '@services/api';
import delay from '@services/utils/delay';

// dispatch
// Запрос списка рабочих сессий
export const requestDevices = async ({ commit }) => {
    let result;
    let devicesMap = {};

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestDevices');
        commit('clearDevices');
        commit('clearDevicesMap');

        result = await Api.getDevices();
        let devices = result.data.filter(device => device.name && device.lora_key);
        devices.sort((a, b) => {
            if (a.name > b.name) {
                return 1;
            } else if (a.name === b.name) {
                return 0;
            } else {
                return -1;
            }
        });

        devices.forEach(device => (devicesMap[device.id] = device));

        commit('setDevices', devices);
        commit('setDevicesMap', devicesMap);
    } catch (err) {
        commit('setError', {
            type: 'requestDevices',
            error: err
        });
    }
};

// Запрос списка работников
export const requestWorkers = async ({ commit }) => {
    let result = [];
    let workersMap = {};

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestWorkers');
        commit('clearWorkersData');
        commit('clearWorkersMap');

        result = await Api.workers();
        result.forEach(worker => (workersMap[worker.id] = worker));

        commit('setWorkersData', result);
        commit('setWorkersMap', workersMap);
    } catch (err) {
        commit('setError', {
            type: 'requestWorkers',
            error: err
        });
    }
};

// Запрос списка рабочих сессий
export const requestWorkSessions = async ({ getters, commit }, deviceId) => {
    if (deviceId === undefined) return;

    let { projectId } = getters;

    let result = [];

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestWorkSessions');

        result = await Api.workSessions(projectId, deviceId);

        commit('setWorkSessionsData', {
            deviceId,
            data: result
        });

        return result;
    } catch (err) {
        commit('setError', {
            type: 'requestWorkSessions',
            error: err
        });
    } finally {
        // Здесь отключение флага setSessionProcessing нужно для тех случаев, когда requestWorkSessions вызывается
        // из createSession, updateSession и deleteSession для обновления отображаемых данных после операций над ними
        commit('setSessionProcessing', false);
    }
};

// Запрос списка time_resource данных
export const requestTimeResource = async ({ getters, commit }) => {
    let result = [];
    let timeResourceMap = {};

    let { projectId } = getters;
    if (projectId === null) return result;

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestTimeResource');
        commit('clearTimeResourceData');
        commit('clearTimeResourceMap');

        result = await Api.timeResource(projectId);

        result.forEach(({ id }, index) => {
            timeResourceMap[id] = index;
        });

        commit('setTimeResourceData', result);
        commit('setTimeResourceMap', timeResourceMap);
    } catch (err) {
        commit('setError', {
            type: 'requestTimeResource',
            error: err
        });
    }
};

// Отправка данных для создания новой сессии
export const createSession = async ({ getters, commit, dispatch }) => {
    if (!getters.editModalDataReady) return false;

    let result = {};
    let { device_id, time_resource_id, start_date, finish_date } = getters.editModalData;

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'createSession');
        commit('setSessionProcessing', true);

        result = await Api.createSession({ device_id, time_resource_id, start_date, finish_date });

        if (!finish_date) {
            finish_date = new Date().toISOString();
        }

        await Api.recalculateAll(start_date, finish_date);

        commit('setEditModalData', {
            device_id: null,
            time_resource_id: null
        });

        // Если не было ошибки при добавлении сессии и дошло сюда,
        // запросим снова список сессий для того устройства, которому добавляли сессию
        // При добавлении новой сессии не нужно ждать обновления данных в таблице
        dispatch('requestWorkSessions', device_id);

        return result;
    } catch (err) {
        commit('setError', {
            type: 'createSession',
            error: err
        });

        // Если будет ошибка при добавлении сессии, снимаем флаг, отмечающий работу над данными сессий
        // Если ошибки не будет, этот флаг будет снят после получения новых данных в методе requestWorkSessions
        commit('setSessionProcessing', false);
    }
};

// Обновление данных существующей сессии
export const updateSession = async ({ getters, commit, dispatch }) => {
    if (!getters.editModalDataReady) return false;

    let result = {};
    let { work_session_id, device_id, time_resource_id, start_date, finish_date } = getters.editModalData;

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'updateSession');
        commit('setSessionProcessing', true);

        result = await Api.updateSession(work_session_id, { device_id, time_resource_id, start_date, finish_date });

        if (!finish_date) {
            finish_date = new Date().toISOString();
        }

        await Api.recalculateAll(start_date, finish_date);

        commit('setEditModalData', {
            device_id: null,
            time_resource_id: null
        });

        // При редактировании данных сессии нужно будет дожидаться запроса с обновленными данными,
        // а до этого момента блокировать в интерфейсе возможность дальнейшего взаимодействия
        // с уже не актуальной информацией о сессиях
        await dispatch('requestWorkSessions', device_id);

        // После успешного обновления данных закрываем модалку редактирования
        commit('setEditModalOpen', false);

        return result;
    } catch (err) {
        commit('setError', {
            type: 'updateSession',
            error: err
        });

        // Если будет ошибка при добавлении сессии, снимаем флаг, отмечающий работу над данными сессий
        // Если ошибки не будет, этот флаг будет снят после получения новых данных в методе requestWorkSessions
        commit('setSessionProcessing', false);
    }
};

// Удаление существующей сессии
export const deleteSession = async ({ getters, commit, dispatch }) => {
    let { work_session_id, device_id } = getters.deleteModalData;

    if (work_session_id === null) return false;

    let result = {};

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'deleteSession');
        commit('setSessionProcessing', true);

        result = await Api.deleteSession(work_session_id);

        // При удалении сессии нужно дождаться ответа с обновленным списком сессий
        await dispatch('requestWorkSessions', device_id);

        return result;
    } catch (err) {
        commit('setError', {
            type: 'deleteSession',
            error: err
        });

        // Если будет ошибка при добавлении сессии, снимаем флаг, отмечающий работу над данными сессий
        // Если ошибки не будет, этот флаг будет снят после получения новых данных в методе requestWorkSessions
        commit('setSessionProcessing', false);
    }
};
