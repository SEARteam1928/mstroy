import checkIntersectionArrays from '@services/utils/checkIntersectionArrays';
import shortName from '@services/utils/shortName';
import isFalse from '@services/utils/isFalse';
import sortByNameField from '@services/utils/sortByNameField';

export const allDevices = state => [...state.allDevices].sort(sortByNameField);
export const allDevicesMap = state => state.allDevicesMap;
export const historySize = state => state.historySize;
export const isActiveRequestAllDevices = state => state.isActiveRequestAllDevices;
export const allDevicesRequestTimestamp = state => state.allDevicesRequestTimestamp;

export const selectedDevicesId = state => state.selectedDevicesId;
export const isSelectedDeviceId = state => id => {
    let index = state.selectedDevicesId.findIndex(_id => _id === id);

    return index > -1 ? true : false;
};
export const isAllSelectedDevicesId = state => {
    let allDevicesId = state.allDevices.map(({ id }) => id);

    return checkIntersectionArrays(allDevicesId, state.selectedDevicesId);
};
export const getDeviceById = state => id => {
    let index = state.allDevicesMap[id];

    return state.allDevices[index];
};

export const getDeviceByRfid = state => rfid => {
    return state.allDevices.find(({ rfidValue }) => {
        if (isFalse(rfidValue) || isFalse(rfid)) return;

        return rfidValue.trim() === rfid.trim();
    });
};

export const deviceFilters = state => state.deviceFilters;
export const deviceListWithFilters = state => {
    let devices = state.allDevices;

    state.deviceFilters.forEach(({ filter }) => {
        devices = filter(devices);
    });

    return devices;
};

export const isActiveRequestAllTimeResources = state => state.isActiveRequestAllTimeResources;
export const allTimeResources = state => state.allTimeResources;
export const allTimeResourcesMap = state => state.allTimeResourcesMap;

export const availableWorkers = state => {
    let availableWorkers = state.allTimeResources.map(({ worker, rowId }) => {
        if (!worker) return;

        let { lastName, firstName, surname, rowId: worker_id } = worker;
        let owner = {
            id: worker_id,
            last_name: lastName,
            first_name: firstName,
            surname
        };

        let name = shortName(lastName, firstName, surname, true);
        return { name, worker_id, id: rowId, owner };
    });

    // Сортировка списка работников по имени
    availableWorkers.sort(sortByNameField);

    return availableWorkers;
};

export const getWorkerById = (_, getters) => id => {
    return getters.availableWorkers.find(({ worker_id }) => worker_id === id);
};
export const getWorkerByTRId = (_, getters) => id => {
    return getters.availableWorkers.find(({ id: _id }) => _id === id);
};

export const editSessionModalData = state => state.editSessionModalData;
export const editSessionModalDataReady = state => {
    let { id, timeResourceId, startDate } = state.editSessionModalData;
    if (id === null || timeResourceId === null || startDate === null) {
        return false;
    }

    return true;
};
export const editSessionModalOpen = state => state.editSessionModalOpen;

export const deleteSessionModalData = state => state.deleteSessionModalData;
export const deleteSessionModalOpen = state => state.deleteSessionModalOpen;

// Получение флага отправки запроса для создания новой сессии
export const sessionProcessing = state => state.sessionProcessing;

export const waitDeviceScannerSignal = state => state.waitDeviceScannerSignal;
export const waitConfirmChangeRfid = state => state.waitConfirmChangeRfid;
export const waitConfirmDeleteRfid = state => state.waitConfirmDeleteRfid;
export const newRfid = state => state.newRfid;

export const deviceProcession = state => state.deviceProcession;

export const giveDeviceModalData = state => state.giveDeviceModalData;
export const giveDeviceModalOpen = state => state.giveDeviceModalOpen;
