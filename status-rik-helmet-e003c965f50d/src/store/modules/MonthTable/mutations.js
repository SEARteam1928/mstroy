export const setProjectId = (state, projectId) => (state.projectId = projectId);
export const setPeriodDate = (state, periodDate) => {
    state.periodDate = {
        ...state.periodDate,
        ...periodDate
    };
};
export const clearPeriodDate = state => {
    state.periodDate = {
        from: null,
        to: null
    };
};

export const setHoursData = (state, hoursData) => (state.hoursData = hoursData);
export const clearHoursData = state => (state.hoursData = []);

export const setDataIsLoading = (state, loading) => (state.dataIsLoading = loading);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
