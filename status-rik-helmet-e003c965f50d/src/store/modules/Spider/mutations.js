// commit
export const setAllPlannedWorks = (state, data) => (state.allPlannedWorks.data = data);
export const clearAllPlannedWorks = state => (state.allPlannedWorks.data = []);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
