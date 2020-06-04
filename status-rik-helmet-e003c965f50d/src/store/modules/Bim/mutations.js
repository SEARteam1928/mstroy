export const setProjectId = (state, projectId) => (state.projectId = projectId);
export const setActualTransactionId = (state, id) => (state.actualTransactionId = id);

export const setAllProjectElements = (state, allProjectElements) => (state.allProjectElements = allProjectElements);
export const clearAllProjectElements = state => (state.allProjectElements = []);
export const setAllProjectElementsMap = (state, map) => (state.allProjectElementsMap = map);
export const clearAllProjectElementsMap = state => (state.allProjectElementsMap = {});
export const setSelectedProjectElement = (state, projectElement) => (state.selectedProjectElement = projectElement);
export const clearSelectedProjectElement = state => (state.selectedProjectElement = null);

export const setProjectsRequested = (state, isRequested) => (state.projectsRequested = isRequested);
export const setProjects = (state, projects) => (state.projects = projects);
export const clearProjects = state => (state.projects = []);
export const setSelectedProject = (state, selectedProject) => (state.selectedProject = selectedProject);
export const clearSelectedProject = state => (state.selectedProject = null);

export const setSelectedCompleteData = (state, data) => {
    state.selectedCompleteData = {
        ...state.selectedCompleteData,
        ...data
    };
};
export const clearSelectedCompleteData = state => {
    state.selectedCompleteData = {
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
    };
};

export const setSelectedMetaObject = (state, selectedMetaObject) => (state.selectedMetaObject = selectedMetaObject);
export const clearSelectedMetaObject = state => (state.selectedMetaObject = null);

export const setIsShowComponentTreeModel = (state, isShow) => (state.isShowComponentTreeModel = isShow);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
