export default {
    periodFrom: null,
    periodTo: null,
    projectId: null,

    PerformanceAnalyzeTotalData: [],
    PerformanceAnalyzeTotalDataMap: {},

    selectedMonth: null,

    PerformanceAnalyzeZonesData: {},

    PerformanceKPIData: {},

    workZones: [],
    workZonesMap: {},
    outOfZoneColor: '#f55f74',

    selectedZoneId: null,
    selectedZoneName: null,

    ModalZoneTableData: {
        total: null,
        work_hours: null
    },

    selectedWorkerId: null,
    selectedWorkerData: {},

    ModalWorkerTableData: [],

    ModalWorkerMapPeriodFrom: null,
    ModalWorkerMapPeriodTo: null,

    onlyActiveCoordinates: true,
    deviceCoordinatesLoading: false,
    deviceCoordinates: [],

    moduleErrors: {
        requestWorkAnalyzeTotalData: false,
        requestWorkAnalyzeComparing: false,
        requestWorkAnalyzeWorkCost: false,
        requestWorkAnalyzeWorkCostObject: false,
        requestWorkAnalyzeWorkCostWorker: false,
        requestSelectedWorkerData: false,
        requestDeviceCoordinates: false,
        TrackPlayBackLatLngs: false,
        requestWorkZones: false
    }
};
