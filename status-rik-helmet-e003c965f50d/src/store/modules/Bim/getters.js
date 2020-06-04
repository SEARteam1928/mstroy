export const projectId = state => state.projectId;
export const actualTransactionId = state => state.actualTransactionId;

export const allProjectElements = state => state.allProjectElements;
export const allProjectElementsMap = state => state.allProjectElementsMap;
export const getProjectElement = state => id => state.allProjectElementsMap[id];
export const selectedProjectElement = state => state.selectedProjectElement;

export const projectsRequested = state => state.projectsRequested;
export const projects = state => state.projects;
export const selectedProject = state => state.selectedProject;
export const selectedMetaObject = state => state.selectedMetaObject;

export const selectedCompleteData = state => state.selectedCompleteData;

export const isShowComponentTreeModel = state => state.isShowComponentTreeModel;

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
