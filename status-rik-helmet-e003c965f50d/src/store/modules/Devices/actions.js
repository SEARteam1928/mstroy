import Api from '@services/api';
import { buildDeviceList } from '@services/dataConverter';

export const requestDeviceList = async ({ getters, commit }) => {
    let { historySize } = getters;

    try {
        commit('clearError', 'requestDeviceList');

        let res = await Api.getDevicesWithCoords(historySize);
        let { deviceList, deviceMap } = buildDeviceList(res);

        commit('setDeviceList', deviceList);
        commit('setDeviceListMap', deviceMap);
    } catch (err) {
        commit('setError', {
            type: 'requestDeviceList',
            error: err
        });
    }
};

export const requestCreateDevice = async ({ getters, commit }) => {
    let { editModalData, editModalReady } = getters;
    if (!editModalReady) return;

    try {
        commit('clearError', 'requestCreateDevice');
        commit('setCreatingDevice', true);

        let res = await Api.createDevice(editModalData);
        let createdDevice = res.data.createDevice.device;
        console.log('createdDevice: ', createdDevice);

        commit('clearEditModalData');

        return createdDevice;
    } catch (err) {
        commit('setError', {
            type: 'requestCreateDevice',
            error: err
        });

        return false;
    } finally {
        commit('setCreatingDevice', false);
    }
};

export const requestDeleteDevice = async ({ getters, commit }) => {
    let { id } = getters.deleteModalData;
    if (id === null || id === undefined) return;

    try {
        commit('clearError', 'requestDeleteDevice');

        await Api.deleteDevice(id);
        commit('clearDeleteModalData');

        return true;
    } catch (err) {
        commit('setError', {
            type: 'requestDeleteDevice',
            error: err
        });

        return false;
    }
};

export const requestEditDevice = async ({ getters, commit }) => {
    let { editModalData, editModalReady } = getters;
    if (!editModalReady) return;

    try {
        commit('clearError', 'requestEditDevice');
        commit('setCreatingDevice', true);

        let res = await Api.updateDevice(editModalData);
        let updatedDevice = res.data.updateDevice.device;

        commit('clearEditModalData');

        return updatedDevice;
    } catch (err) {
        commit('setError', {
            type: 'requestEditDevice',
            error: err
        });

        return false;
    } finally {
        commit('setCreatingDevice', false);
    }
};
