import {
    MonthTable,
    WorkPerformance,
    LaborCostChart,
    ObjectMap,
    Map,
    Devices,
    DevicesRawData,
    WorkZone,
    WorkSessions,
    DevicesSessions
} from '../scenarios';

export default [
    {
        path: 'monthtable',
        name: 'monthtable',
        meta: {
            headerTitle: 'Табель',
            scenarios: MonthTable
        },
        component: () => import('pages/MonthTable.vue')
    },
    {
        path: 'workperformance',
        name: 'workPerformance',
        meta: {
            headerTitle: 'Трудозатраты',
            scenarios: WorkPerformance
        },
        component: () => import('pages/WorkPerformance.vue')
    },
    {
        path: 'laborcostchart',
        name: 'laborcostchart',
        meta: {
            headerTitle: 'График',
            scenarios: LaborCostChart
        },
        component: () => import('pages/LaborCostChart.vue')
    },
    {
        path: 'objectmap',
        name: 'objectmap',
        meta: {
            headerTitle: 'Карта',
            scenarios: ObjectMap
        },
        component: () => import('pages/ObjectMap.vue')
    },
    {
        path: 'map',
        name: 'map',
        meta: {
            headerTitle: 'Трек',
            scenarios: Map
        },
        component: () => import('pages/Map.vue')
    },
    {
        path: 'devices',
        name: 'devices',
        meta: {
            headerTitle: 'Устройства',
            scenarios: Devices
        },
        component: () => import('pages/Devices.vue')
    },
    {
        path: 'devicesrawdata',
        name: 'devicesrawdata',
        meta: {
            headerTitle: 'Данные',
            scenarios: DevicesRawData
        },
        component: () => import('pages/DevicesRawData.vue')
    },
    {
        path: 'workzone',
        name: 'workzone',
        meta: {
            headerTitle: 'Рабочие зоны',
            scenarios: WorkZone
        },
        component: () => import('pages/WorkZone.vue')
    },
    {
        path: 'worksessions',
        name: 'worksessions',
        meta: {
            headerTitle: 'Сессии',
            scenarios: WorkSessions
        },
        component: () => import('pages/WorkSessions.vue')
    },
    {
        path: 'devicessessions',
        name: 'devicessessions',
        meta: {
            headerTitle: 'Устройства + Сессии',
            scenarios: DevicesSessions
        },
        component: () => import('pages/DevicesSessions.vue')
    }
];
