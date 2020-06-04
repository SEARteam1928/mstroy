export default {
    projectId: null,

    devices: [],
    devicesMap: {},
    workersData: [],
    workersMap: {},
    workSessionsData: {},
    timeResourceData: [],
    timeResourceMap: {},

    selectedPeriod: {
        from: null,
        to: null
    },
    selectedDevice: null,

    editModalOpen: false,
    deleteModalOpen: false,

    // Данные для создания новой сессии
    editModalData: {
        work_session_id: null,
        device_id: null,
        time_resource_id: null,
        start_date: null,
        finish_date: null
    },

    deleteModalData: {
        work_session_id: null,
        device_id: null
    },

    // Флаг, отмечающий, активен ли сейчас запрос с мутацией
    sessionProcessing: false,

    moduleErrors: {
        requestDevices: false,
        requestWorkers: false,
        requestWorkSessions: false,
        requestTimeResource: false,
        createSession: false,
        updateSession: false,
        deleteSession: false
    }
};
