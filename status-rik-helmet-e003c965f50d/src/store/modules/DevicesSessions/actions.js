import Api from '@services/api';
import newCoordsSubscription from '@services/api/endpoints/graphql/devices/newCoordsSubscription.gql';
import buildDeviceList from '@services/dataConverter/buildDeviceList';
import isFalse from '@services/utils/isFalse';

export const requestAllDevices = async ({ getters, commit }, historySize) => {
    if (!historySize) historySize = getters.historySize;

    try {
        commit('clearError', 'requestAllDevices');
        commit('setIsActiveRequestAllDevices', true);

        let res = await Api.getDevicesWithCoords(historySize);
        let { deviceList, deviceMap } = buildDeviceList(res);
        let timestamp = +new Date();

        commit('setAllDevicesRequestTimestamp', timestamp);
        commit('setAllDevices', deviceList);
        commit('setAllDevicesMap', deviceMap);
    } catch (err) {
        commit('setError', {
            type: 'requestAllDevices',
            error: err
        });
    } finally {
        commit('setIsActiveRequestAllDevices', false);
    }
};

export const subscriptionNewCoords = async ({ getters, commit }) => {
    return Api.apollo
        .subscribe({
            query: newCoordsSubscription,
            variables: {}
        })
        .subscribe({
            next(data) {
                // Notify your application with the new arrived data
                console.log('sub data: ', data);
            }
        });
};

export const requestAllTimeResources = async ({ getters, commit }) => {
    let { projectId } = getters;
    if (isFalse(projectId)) return;

    try {
        commit('clearError', 'requestAllTimeResources');
        commit('setIsActiveRequestAllTimeResources', true);

        let res = await Api.allTimeResources({ 'projectIdEq': projectId });
        let allTimeResources = res.data.allTimeResources;
        let allTimeResourcesMap = {};
        allTimeResources.forEach(({ rowId }, index) => (allTimeResourcesMap[rowId] = index));

        commit('setAllTimeResources', allTimeResources);
        commit('setAllTimeResourcesMap', allTimeResourcesMap);
    } catch (err) {
        commit('setError', {
            type: 'requestAllTimeResources',
            error: err
        });
    } finally {
        commit('setIsActiveRequestAllTimeResources', false);
    }
};

export const requestCreateSession = async ({ getters, commit }, sessionData) => {
    if (!sessionData) sessionData = getters.editSessionModalData;

    let result = {};
    let { startDate, finishDate, deviceId, timeResourceId } = sessionData;
    if (isFalse(deviceId) || isFalse(timeResourceId) || isFalse(startDate) || isFalse(finishDate)) return;

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestCreateSession');
        commit('setSessionProcessing', true);

        result = await Api.createWorkSession({ startDate, finishDate, deviceId, timeResourceId });

        commit('setEditSessionModalData', {
            deviceId: null,
            timeResourceId: null
        });

        return result.data.createWorkSession.worksession;
    } catch (err) {
        commit('setError', {
            type: 'requestCreateSession',
            error: err
        });
    } finally {
        commit('setSessionProcessing', false);
    }
};

export const requestUpdateSession = async ({ getters, commit }, sessionData) => {
    if (!sessionData) sessionData = getters.editSessionModalData;

    let { id, startDate, finishDate, deviceId, timeResourceId } = sessionData;
    if (isFalse(id) || isFalse(deviceId) || isFalse(timeResourceId) || isFalse(startDate) || isFalse(finishDate))
        return;

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestUpdateSession');
        commit('setSessionProcessing', true);

        let result = await Api.updateWorkSession({ id, startDate, finishDate, deviceId, timeResourceId });

        commit('clearEditSessionModalData');

        return result.data.updateWorkSession.worksession;
    } catch (err) {
        commit('setError', {
            type: 'requestUpdateSession',
            error: err
        });
    } finally {
        commit('setSessionProcessing', false);
    }
};

export const requestDeleteSession = async ({ getters, commit }, sessionData) => {
    if (!sessionData) sessionData = getters.deleteSessionModalData;

    let { id } = sessionData;
    if (isFalse(id)) return;

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestDeleteSession');
        commit('setSessionProcessing', true);

        let result = await Api.deleteWorkSession({ id });

        commit('clearDeleteSessionModalData');

        return result.data.deleteWorkSession.ok;
    } catch (err) {
        commit('setError', {
            type: 'requestDeleteSession',
            error: err
        });
    } finally {
        commit('setSessionProcessing', false);
    }
};

export const requestEditDevice = async ({ commit }, deviceData) => {
    try {
        commit('clearError', 'requestEditDevice');
        commit('setDeviceProcession', true);

        let res = await Api.updateDevice(deviceData);
        let updatedDevice = res.data.updateDevice.device;

        return updatedDevice;
    } catch (err) {
        commit('setError', {
            type: 'requestEditDevice',
            error: err
        });

        return false;
    } finally {
        commit('setDeviceProcession', false);
    }
};

export const requestAllWorkSessions = async ({ commit }, { filters, pagination, orderBy }) => {
    try {
        commit('clearError', 'requestAllWorkSessions');
        commit('setDeviceProcession', true);

        let res = await Api.allWorkSessions(filters, pagination, orderBy);
        let allWorkSessions = res.data.allWorkSessions;

        return allWorkSessions;
    } catch (err) {
        commit('setError', {
            type: 'requestAllWorkSessions',
            error: err
        });

        return false;
    }
};

export const requestDeviceCoordinates = async ({ commit }, params = {}) => {
    let { selectedDevicesId, from, to } = params;

    if (selectedDevicesId.length === 0 || isFalse(from) || isFalse(to)) return;

    try {
        commit('clearError', 'requestDeviceCoordinates');

        let filters = {
            'deviceIdIn': selectedDevicesId,
            'createdAtGte': from,
            'createdAtLte': to
        };

        let orderBy = {
            'createdAtAsc': true
        };

        let res = await Api.allDeviceCoordinates(filters, orderBy);
        let allDeviceCoordinates = res.data.allDeviceCoordinates;

        return allDeviceCoordinates;
    } catch (err) {
        commit('setError', {
            type: 'requestDeviceCoordinates',
            error: err
        });
    }
};
