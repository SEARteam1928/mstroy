import Api from '@services/api';
import {
    buildWorkAnalyzeTotalData,
    buildPerformanceAnalyzeData,
    buildWorkAnalyzeWorkCostData
} from '@services/dataConverter';

// dispatch
//  Список из строк "Итого" по месяцам для таблицы "Трудозатраты по различным источникам" в PerformanceAnalyze
export const requestWorkAnalyzeTotalData = async ({ getters, commit }) => {
    let result = [];
    let map = {};
    let { projectId } = getters;
    if (projectId === null) return result;

    try {
        commit('clearError', 'requestWorkAnalyzeTotalData');
        commit('clearPerformanceAnalyzeTotalData');
        commit('clearPerformanceAnalyzeTotalDataMap');

        let res = await Api.workAnalyzeTotal(projectId);
        result = buildWorkAnalyzeTotalData(res.total);

        // Собирает карту "selectedMonth": индекс этого месяца в PerformanceAnalyzeTotalData
        result.forEach(({ day }, index) => (map[day] = index));

        commit('setPerformanceAnalyzeTotalData', result);
        commit('setPerformanceAnalyzeTotalDataMap', map);
    } catch (err) {
        commit('setError', {
            type: 'requestWorkAnalyzeTotalData',
            error: err
        });
    }
};

// Данные для таблицы "Трудозатраты по различным источникам" в PerformanceAnalyze
export const requestWorkAnalyzeComparing = async ({ getters, commit }) => {
    let result = {};
    let { projectId, selectedMonth, periodFrom, periodTo } = getters;
    if (projectId === null || !periodFrom || !periodTo) return result;

    try {
        commit('clearError', 'requestWorkAnalyzeComparing');

        result = await Api.workAnalyzeComparing(projectId, periodFrom, periodTo);
        let performanceFact = Math.round(result.total.effective_percentage) + '%';
        commit('setPerformanceKPIData', {
            month: selectedMonth,
            data: { performanceFact }
        });

        let data = buildPerformanceAnalyzeData(result.work_hours);

        commit('setPerformanceAnalyzeData', {
            selectedMonth,
            data
        });
    } catch (err) {
        commit('setError', {
            type: 'requestWorkAnalyzeComparing',
            error: err
        });
    }
};

// Данные для таблицы "Анализ трудозатрат по зонам производства работ" в PerformanceAnalyzeZones
export const requestWorkAnalyzeWorkCost = async ({ getters, commit }) => {
    let result = [];
    let { projectId, selectedMonth, periodFrom, periodTo } = getters;
    if (projectId === null || !periodFrom || !periodTo) return result;

    try {
        commit('clearError', 'requestWorkAnalyzeWorkCost');

        let res = await Api.workAnalyzeWorkCost(projectId, periodFrom, periodTo);
        let notPerformanceFact = Math.round(res.work_not_in_zone.percentages) + '%';
        commit('setPerformanceKPIData', {
            month: selectedMonth,
            data: { notPerformanceFact }
        });

        result = buildWorkAnalyzeWorkCostData(res);

        commit('setPerformanceAnalyzeZonesData', {
            month: selectedMonth,
            data: result
        });
    } catch (err) {
        commit('setError', {
            type: 'requestWorkAnalyzeWorkCost',
            error: err
        });
    }
};

// Данные для таблицы "Анализ данных по зоне" в ModalZoneTable
export const requestWorkAnalyzeWorkCostObject = async ({ getters, commit }) => {
    let result = {};
    let { projectId, selectedZoneId, periodFrom, periodTo } = getters;
    if (projectId === null || selectedZoneId === null || !periodFrom || !periodTo) return result;

    try {
        commit('clearError', 'requestWorkAnalyzeWorkCostObject');

        result = await Api.workAnalyzeWorkCostObject(projectId, selectedZoneId, periodFrom, periodTo);

        commit('setModalZoneTableData', result);
    } catch (err) {
        commit('setError', {
            type: 'requestWorkAnalyzeWorkCostObject',
            error: err
        });
    }
};

// Данные для таблицы PerformanceAnalyzeZones в ModalWorker
export const requestWorkAnalyzeWorkCostWorker = async ({ getters, commit }) => {
    let result = {};
    let { projectId, selectedWorkerId, periodFrom, periodTo } = getters;
    if (projectId === null || selectedWorkerId === null || !periodFrom || !periodTo) return result;

    try {
        commit('clearError', 'requestWorkAnalyzeWorkCostWorker');

        let res = await Api.workAnalyzeWorkCostWorker(projectId, selectedWorkerId, periodFrom, periodTo);
        result = buildWorkAnalyzeWorkCostData(res);

        commit('setModalWorkerTableData', result);
    } catch (err) {
        commit('setError', {
            type: 'requestWorkAnalyzeWorkCostWorker',
            error: err
        });
    }
};

// Данные о выбранном работнике для модалки ModalWorker
export const requestSelectedWorkerData = async ({ getters, commit }) => {
    let result = {};
    let { selectedWorkerId } = getters;
    if (selectedWorkerId === null) return result;

    try {
        commit('clearError', 'requestSelectedWorkerData');

        result = await Api.workers(selectedWorkerId);

        if (!result.query_result) {
            throw new Error('Не правильный формат информации о работнике');
        }

        commit('setSelectedWorkerData', result.query_result);
    } catch (err) {
        commit('setError', {
            type: 'requestSelectedWorkerData',
            error: err
        });
    }
};

// Данные о координатах устройства за выбранный период времени в ModalWorkerMap
export const requestDeviceCoordinates = async ({ getters, commit }) => {
    let result = {};
    let { selectedWorkerId, ModalWorkerMapPeriodFrom, ModalWorkerMapPeriodTo, onlyActiveCoordinates } = getters;
    if (selectedWorkerId === null || !ModalWorkerMapPeriodFrom || !ModalWorkerMapPeriodTo) return result;

    try {
        commit('clearError', 'requestDeviceCoordinates');
        commit('setDeviceCoordinatesLoading', true);

        result = await Api.getCoordinatesByWorker(
            selectedWorkerId,
            ModalWorkerMapPeriodFrom,
            ModalWorkerMapPeriodTo,
            onlyActiveCoordinates,
            true
        );

        commit('setDeviceCoordinates', result);
    } catch (err) {
        commit('setError', {
            type: 'requestDeviceCoordinates',
            error: err
        });
    } finally {
        commit('setDeviceCoordinatesLoading', false);
    }
};

// Данные о рабочих зонах на карте
export const requestWorkZones = async ({ commit }) => {
    let result = [];
    let map = {};

    try {
        commit('clearError', 'requestWorkZones');
        commit('clearWorkZones');
        commit('clearWorkZonesMap');

        let res = await Api.getObjects();
        result = res.data;
        result.forEach(zone => {
            map[zone.id] = zone;
        });

        commit('setWorkZones', result);
        commit('setWorkZonesMap', map);
    } catch (err) {
        commit('setError', {
            type: 'requestWorkZones',
            error: err
        });
    }
};

// Очистка хранилища
export const clearStore = ({ commit }) => {
    commit('setSelectedZoneName', null);
    commit('setSelectedZoneId', null);
    commit('clearPerformanceAnalyzeTotalData');
    commit('clearPerformanceAnalyzeTotalDataMap');
    commit('clearPerformanceAnalyzeZonesData');
    commit('clearPerformanceKPIData');
    commit('clearWorkZones');
    commit('clearWorkZonesMap');
    commit('clearSelectedMonth');
};
