// commit
export const setSelectedProjectId = (state, selectedProjectId) => (state.selectedProjectId = selectedProjectId);
export const setAllProjects = (state, allProjects) => (state.allProjects = allProjects);
export const setAllProjectsMap = (state, allProjectsMap) => (state.allProjectsMap = allProjectsMap);
export const clearAllProjects = state => (state.allProjects = []);
export const setIsLoadingProjects = (state, isLoadingProjects) => (state.isLoadingProjects = isLoadingProjects);

export const setProjectsFilter = (state, projectsFilter) => (state.projectsFilter = projectsFilter);

export const deleteProject = (state, id) => {
    let index = state.allProjectsMap[id];
    state.allProjects.splice(index, 1);

    let allProjectsMap = {};
    state.allProjects.forEach(({ rowId }, index) => (allProjectsMap[rowId] = index));
    state.allProjectsMap = allProjectsMap;
};
export const updateProject = (state, newProject) => {
    let { rowId } = newProject;
    let index = state.allProjectsMap[rowId];
    let oldProject = state.allProjects[index];

    state.allProjects.splice(index, 1, { ...oldProject, ...newProject });
};
export const addProject = (state, newProject) => {
    state.allProjects.push(newProject);

    let allProjectsMap = {};
    state.allProjects.forEach(({ rowId }, index) => (allProjectsMap[rowId] = index));
    state.allProjectsMap = allProjectsMap;
};

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
