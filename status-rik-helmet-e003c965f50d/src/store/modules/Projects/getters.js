import isFalse from '@services/utils/isFalse';
import sortByNameField from '@services/utils/sortByNameField';

export const selectedProjectId = state => state.selectedProjectId;
export const selectedProject = state => {
    let project = null;
    let { selectedProjectId, allProjectsMap, allProjects } = state;

    let index = allProjectsMap[selectedProjectId];
    if (isFalse(index)) return project;

    project = allProjects[index];

    return project;
};

export const getSelectedProject = state => id => {
    let index = state.allProjectsMap[id];
    return state.allProjects[index];
};

export const allProjects = state => [...state.allProjects].sort(sortByNameField);
export const allProjectsMap = state => state.allProjectsMap;
export const isLoadingProjects = state => state.isLoadingProjects;

export const projectsFilter = state => state.projectsFilter;

export const allProjectsFiltered = state => {
    let result = [];

    let { projectsFilter, allProjects } = state;
    let needle = projectsFilter.toLowerCase();

    result = allProjects.filter(({ name }) => name.toLowerCase().indexOf(needle) > -1);

    return result.sort(sortByNameField);
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
