import Api from '@services/api';
import isFalse from '@services/utils/isFalse';

export const requestDeviceList = async ({ commit }) => {
    try {
        commit('clearError', 'requestDeviceList');
        commit('setIsActiveRequestDeviceList', true);

        let res = await Api.allDevices();
        let deviceList = res.data.allDevices;

        let deviceMap = {};
        deviceList.forEach(({ rowId }, index) => (deviceMap[rowId] = index));

        commit('setDeviceList', deviceList);
        commit('setDeviceListMap', deviceMap);
    } catch (err) {
        commit('setError', {
            type: 'requestDeviceList',
            error: err
        });
    } finally {
        commit('setIsActiveRequestDeviceList', false);
    }
};

export const requestDeviceCoordinates = async ({ getters, commit }) => {
    let { selectedDevicesId, periodDate } = getters;
    let { from, to } = periodDate;

    if (selectedDevicesId.length === 0 || from === null || to === null) return;

    try {
        commit('clearError', 'requestDeviceCoordinates');
        commit('clearDeviceCoordinates');
        commit('setIsActiveRequestDeviceCoordinates', true);

        let res = await Api.allDeviceCoordinates({
            'deviceIdIn': selectedDevicesId,
            'createdAtGte': from,
            'createdAtLte': to
        });
        let allDeviceCoordinates = res.data.allDeviceCoordinates;

        commit('setDeviceCoordinates', allDeviceCoordinates);
    } catch (err) {
        commit('setError', {
            type: 'requestDeviceCoordinates',
            error: err
        });
    } finally {
        commit('setIsActiveRequestDeviceCoordinates', false);
    }
};

// FIXME: Api.getCoordinatesExcel может принимать только 1 id устройства
export const requestDeviceCoordinatesExcel = async ({ getters, commit }) => {
    let { selectedDevicesId, periodDate } = getters;
    let { from, to } = periodDate;

    if (selectedDevicesId.length === 0 || selectedDevicesId.length > 1 || from === null || to === null) return;

    try {
        commit('clearError', 'requestDeviceCoordinatesExcel');
        commit('setIsActiveRequestDeviceCoordinatesExcel', true);

        let res = await Api.getCoordinatesExcel(selectedDevicesId[0], from, to);

        return res;
    } catch (err) {
        commit('setError', {
            type: 'requestDeviceCoordinatesExcel',
            error: err
        });
    } finally {
        commit('setIsActiveRequestDeviceCoordinatesExcel', false);
    }
};
