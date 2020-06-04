export default {
    projectId: null,
    actualTransactionId: null,

    allProjectElements: [],
    allProjectElementsMap: {},
    selectedProjectElement: null,

    projectsRequested: false,
    projects: [],
    selectedProject: null,
    selectedMetaObject: null,

    selectedCompleteData: {
        appId: null,
        constructiveId: null,
        constructiveName: null,
        constructiveCode: null,
        volume: null,
        cost: null,
        measureUnit: null,
        versionStart: null,
        versionFinish: null,
        isComplete: null,
        worksArray: [],
        worksIdArray: [],
        resources: []
    },

    isShowComponentTreeModel: true,

    moduleErrors: {
        requestProjects: false,
        requestAllProjectElements: false,
        requestUpdateConstructiveVersion: false,
        requestWorks: false,
        requestResources: false,
        requestConstructiveByAppId: false
    }
};
