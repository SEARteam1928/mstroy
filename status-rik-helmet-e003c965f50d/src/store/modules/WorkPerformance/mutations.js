import Vue from 'vue';

// commit
export const setPeriodFrom = (state, from) => (state.periodFrom = from);
export const setPeriodTo = (state, to) => (state.periodTo = to);
export const setProjectId = (state, id) => (state.projectId = id);

export const setPerformanceAnalyzeTotalData = (state, data) => (state.PerformanceAnalyzeTotalData = data);
export const clearPerformanceAnalyzeTotalData = state => (state.PerformanceAnalyzeTotalData = []);

export const setPerformanceAnalyzeTotalDataMap = (state, map) => (state.PerformanceAnalyzeTotalDataMap = map);
export const clearPerformanceAnalyzeTotalDataMap = state => (state.PerformanceAnalyzeTotalDataMap = {});

export const setSelectedMonth = (state, month) => (state.selectedMonth = month);
export const clearSelectedMonth = state => (state.selectedMonth = null);

// Данные для таблицы "Трудозатраты по различным источникам" в PerformanceAnalyze
export const setPerformanceAnalyzeData = (state, { selectedMonth, data }) => {
    let { PerformanceAnalyzeTotalDataMap, PerformanceAnalyzeTotalData } = state;
    let totalDataIndex = PerformanceAnalyzeTotalDataMap[selectedMonth];

    let TotalData = PerformanceAnalyzeTotalData[totalDataIndex];
    if (!TotalData) return;

    TotalData.daysData = data;
};

// Данные для таблицы "Анализ трудозатрат по зонам производства работ" в PerformanceAnalyzeZones
export const setPerformanceAnalyzeZonesData = (state, { month, data }) => {
    Vue.set(state.PerformanceAnalyzeZonesData, month, data);
};
export const clearPerformanceAnalyzeZonesData = state => (state.PerformanceAnalyzeZonesData = {});

export const setPerformanceKPIData = (state, { month, data }) => {
    let monthData = state.PerformanceKPIData[month];
    if (!monthData) monthData = {};

    monthData = {
        ...monthData,
        ...data
    };

    Vue.set(state.PerformanceKPIData, month, monthData);
};
export const clearPerformanceKPIData = state => (state.PerformanceKPIData = {});

export const setWorkZones = (state, workZones) => (state.workZones = workZones);
export const clearWorkZones = state => (state.workZones = []);
export const setWorkZonesMap = (state, workZonesMap) => (state.workZonesMap = workZonesMap);
export const clearWorkZonesMap = state => (state.workZonesMap = {});

// id и название выбранной зоны на странице WorkPerformance
export const setSelectedZoneId = (state, id) => (state.selectedZoneId = id);
export const setSelectedZoneName = (state, name) => (state.selectedZoneName = name);

// Данные для таблицы "Анализ данных по зоне" в ModalZoneTable
export const setModalZoneTableData = (state, { total, work_hours }) => {
    state.ModalZoneTableData.total = total;
    state.ModalZoneTableData.work_hours = work_hours;
};
export const clearModalZoneTableData = state => {
    state.ModalZoneTableData.total = null;
    state.ModalZoneTableData.work_hours = null;
};

// id выбранного работника в модалке ModalZone
export const setSelectedWorkerId = (state, id) => (state.selectedWorkerId = id);
export const clearSelectedWorkerId = state => (state.selectedWorkerId = null);
export const setSelectedWorkerData = (state, data) => (state.selectedWorkerData = data);
export const clearSelectedWorkerData = state => (state.selectedWorkerData = {});

// Данные для таблицы PerformanceAnalyzeZones в ModalWorker
export const setModalWorkerTableData = (state, data) => (state.ModalWorkerTableData = data);
export const clearModalWorkerTableData = state => (state.ModalWorkerTableData = []);

export const setModalWorkerMapPeriodFrom = (state, from) => (state.ModalWorkerMapPeriodFrom = from);
export const setModalWorkerMapPeriodTo = (state, to) => (state.ModalWorkerMapPeriodTo = to);

export const setOnlyActiveCoordinates = (state, active) => (state.onlyActiveCoordinates = active);
export const setDeviceCoordinates = (state, coords) => (state.deviceCoordinates = coords);
export const clearDeviceCoordinates = state => (state.deviceCoordinates = []);
export const setDeviceCoordinatesLoading = (state, loading) => (state.deviceCoordinatesLoading = loading);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
