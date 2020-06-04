import Vue from 'vue';
import Vuex from 'vuex';

import WorkPerformance from './modules/WorkPerformance';
import WorkSessions from './modules/WorkSessions';
import WorkZonesObjects from './modules/WorkZonesObjects';
import LaborCostChart from './modules/LaborCostChart';
import Devices from './modules/Devices';
import DevicesRawData from './modules/DevicesRawData';
import Spider from './modules/Spider';
import UsersControl from './modules/UsersControl';
import RolesControl from './modules/RolesControl';
import Scenarios from './modules/Scenarios';
import User from './modules/User';
import MonthTable from './modules/MonthTable';
import Projects from './modules/Projects';
import Bim from './modules/Bim';
import UI from './modules/UI';
import DevicesSessions from './modules/DevicesSessions';
import RfidController from './modules/RfidController';
import GroupsControl from './modules/GroupsControl';
import ProjectsControl from './modules/ProjectsControl';
import Entities from './modules/Entities';

Vue.use(Vuex);

/*
 * If not building with SSR mode, you can
 * directly export the Store instantiation
 */

export default function(/* { ssrContext } */) {
    const Store = new Vuex.Store({
        modules: {
            WorkPerformance,
            WorkSessions,
            WorkZonesObjects,
            LaborCostChart,
            Devices,
            DevicesRawData,
            Spider,
            UsersControl,
            RolesControl,
            Scenarios,
            User,
            MonthTable,
            Projects,
            Bim,
            UI,
            DevicesSessions,
            RfidController,
            GroupsControl,
            ProjectsControl,
            Entities
        },

        // enable strict mode (adds overhead!)
        // for dev mode only
        strict: process.env.DEV
    });

    // Для горячей перезагрузки изменений в структуре хранилища
    if (process.env.DEV && module.hot) {
        module.hot.accept(
            [
                './modules/WorkPerformance',
                './modules/WorkSessions',
                './modules/WorkZonesObjects',
                './modules/LaborCostChart',
                './modules/Devices',
                './modules/DevicesRawData',
                './modules/Spider',
                './modules/UsersControl',
                './modules/RolesControl',
                './modules/Scenarios',
                './modules/User',
                './modules/MonthTable',
                './modules/Projects',
                './modules/Bim',
                './modules/UI',
                './modules/DevicesSessions',
                './modules/RfidController',
                './modules/GroupsControl',
                './modules/ProjectsControl',
                './modules/Entities'
            ],
            () => {
                const newWorkperformance = require('./modules/WorkPerformance').default;
                const newWorkSessions = require('./modules/WorkSessions').default;
                const newWorkZonesObjects = require('./modules/WorkZonesObjects').default;
                const newLaborCostChart = require('./modules/LaborCostChart').default;
                const newDevices = require('./modules/Devices').default;
                const newDevicesRawData = require('./modules/DevicesRawData').default;
                const newSpider = require('./modules/Spider').default;
                const newUsersControl = require('./modules/UsersControl').default;
                const newRolesControl = require('./modules/RolesControl').default;
                const newScenarios = require('./modules/Scenarios').default;
                const newUser = require('./modules/User').default;
                const newMonthTable = require('./modules/MonthTable').default;
                const newProjects = require('./modules/Projects').default;
                const newBim = require('./modules/Bim').default;
                const newUI = require('./modules/UI').default;
                const newDevicesSessions = require('./modules/DevicesSessions').default;
                const newRfidController = require('./modules/RfidController').default;
                const newGroupsControl = require('./modules/GroupsControl').default;
                const newProjectsControl = require('./modules/ProjectsControl').default;
                const newEntities = require('./modules/Entities').default;
                Store.hotUpdate({
                    modules: {
                        WorkPerformance: newWorkperformance,
                        WorkSessions: newWorkSessions,
                        WorkZonesObjects: newWorkZonesObjects,
                        LaborCostChart: newLaborCostChart,
                        Devices: newDevices,
                        DevicesRawData: newDevicesRawData,
                        Spider: newSpider,
                        UsersControl: newUsersControl,
                        RolesControl: newRolesControl,
                        Scenarios: newScenarios,
                        User: newUser,
                        MonthTable: newMonthTable,
                        Projects: newProjects,
                        Bim: newBim,
                        UI: newUI,
                        DevicesSessions: newDevicesSessions,
                        RfidController: newRfidController,
                        GroupsControl: newGroupsControl,
                        ProjectsControl: newProjectsControl,
                        Entities: newEntities
                    }
                });
            }
        );
    }

    return Store;
}
