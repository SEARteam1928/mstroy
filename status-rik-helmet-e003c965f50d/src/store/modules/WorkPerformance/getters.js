import { buildTrackPlaybackDataByWorker } from '@services/dataConverter';

export const periodFrom = state => state.periodFrom;
export const periodTo = state => state.periodTo;
export const projectId = state => state.projectId;

export const PerformanceAnalyzeTotalData = state => state.PerformanceAnalyzeTotalData;
export const PerformanceAnalyzeTotalDataMap = state => state.PerformanceAnalyzeTotalDataMap;

export const selectedMonth = state => state.selectedMonth;

export const selectedPeriod = state => {
    let result = { from_date: null, to_date: null };

    let { selectedMonth, PerformanceAnalyzeTotalDataMap, PerformanceAnalyzeTotalData } = state;
    let totalDataIndex = PerformanceAnalyzeTotalDataMap[selectedMonth];
    if (totalDataIndex === undefined) return result;

    let TotalData = PerformanceAnalyzeTotalData[totalDataIndex];
    if (TotalData === undefined) return result;

    let { from_date, to_date } = TotalData;
    result = { from_date, to_date };

    return result;
};

// export const PerformanceAnalyzeData = state => state.PerformanceAnalyzeData;
export const PerformanceAnalyzeZonesData = state => state.PerformanceAnalyzeZonesData;

export const workZones = state => state.workZones;
export const workZonesMap = state => state.workZonesMap;

export const PerformanceKPIData = state => {
    let result = [];
    let { selectedMonth, PerformanceKPIData } = state;

    let data = PerformanceKPIData[selectedMonth];
    if (data instanceof Object && data.performanceFact !== undefined && data.notPerformanceFact !== undefined) {
        result = [
            {
                name: 'Доля подтвержденных трудозатрат',
                fact: data.performanceFact,
                target: '90%'
            },
            {
                name: 'Доля непроизводительного труда',
                fact: data.notPerformanceFact,
                target: '15%'
            }
        ];
    }

    return result;
};

export const PerformanceChartData = state => {
    let result = [];
    let { selectedMonth, PerformanceAnalyzeZonesData, outOfZoneColor, workZones, workZonesMap } = state;

    let zonesData = PerformanceAnalyzeZonesData[selectedMonth];
    let defaultColor = outOfZoneColor;
    if (!(zonesData instanceof Array) || !zonesData.length || !workZones.length) return result;

    zonesData.forEach(({ pp, name, in_zone_hours, object_id }) => {
        if (pp === undefined) return;

        let zoneColor = workZonesMap[object_id] && workZonesMap[object_id].color;
        result.push({
            object_id,
            name,
            value: in_zone_hours,
            color: zoneColor || defaultColor
        });
    });

    return result;
};

export const selectedZoneId = state => state.selectedZoneId;
export const selectedZoneName = state => state.selectedZoneName;

export const ModalZoneTableData = state => state.ModalZoneTableData;
export const ModalZoneChartData = state => {
    let result = [];
    if (!state.ModalZoneTableData.work_hours) return result;

    result = state.ModalZoneTableData.work_hours.map(({ worker, worker_id, in_zone_hours }) => {
        return {
            worker_id,
            name: worker,
            value: in_zone_hours
        };
    });

    return result;
};

export const selectedWorkerId = state => state.selectedWorkerId;
export const selectedWorkerData = state => state.selectedWorkerData;
export const selectedWorkerFullName = state => {
    let lName = state.selectedWorkerData.last_name;
    let fName = state.selectedWorkerData.first_name;
    let sName = state.selectedWorkerData.surname;
    if (!lName || !fName || !sName) return null;

    let fullName = `${lName} ${fName} ${sName}`;

    return fullName;
};
export const selectedWorkerShortName = state => {
    let lName = state.selectedWorkerData.last_name;
    let fName = state.selectedWorkerData.first_name;
    let sName = state.selectedWorkerData.surname;
    if (!lName || !fName || !sName) return null;

    let shortName = `${lName} ${fName[0]}.${sName[0]}.`;

    return shortName;
};

export const selectedWorkerHelmetId = state => {
    let id = null;
    if (typeof state.selectedWorkerData.helmet_name === 'string') {
        id = state.selectedWorkerData.helmet_name;
    }

    return id;
};

export const ModalWorkerTableData = state => state.ModalWorkerTableData;

export const ModalWorkerMapPeriodFrom = state => state.ModalWorkerMapPeriodFrom;
export const ModalWorkerMapPeriodTo = state => state.ModalWorkerMapPeriodTo;

export const onlyActiveCoordinates = state => state.onlyActiveCoordinates;
export const deviceCoordinates = state => state.deviceCoordinates;
export const deviceCoordinatesLoading = state => state.deviceCoordinatesLoading;
export const TrackPlayBackLatLngs = (state, getters) => {
    let result = [];
    if (!getters.selectedWorkerFullName || !state.deviceCoordinates.length) {
        return result;
    }

    result = buildTrackPlaybackDataByWorker({
        alt: true,
        altProp: 'ActivityLevel',
        workerName: getters.selectedWorkerFullName,
        deviceCoordinates: state.deviceCoordinates
    });

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
