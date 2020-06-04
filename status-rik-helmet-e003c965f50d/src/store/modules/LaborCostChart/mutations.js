import Vue from 'vue';

// commit
export const setProjectId = (state, id) => (state.projectId = id);

export const setPeriodDate = (state, periodDate) => {
    state.periodDate = {
        ...state.periodDate,
        ...periodDate
    };
};
export const clearPeriodDate = state => (state.periodDate = { from: null, to: null });

export const setIsLoading = (state, isLoading) => (state.isLoading = isLoading);

export const setNearObjectsMap = (state, map) => (state.nearObjectsMap = map);
export const clearNearObjectsMap = state => (state.nearObjectsMap = {});

export const setNearObjectsChartData = (state, nearObjectsChartData) =>
    (state.nearObjectsChartData = nearObjectsChartData);
export const clearNearObjectsChartData = state => (state.nearObjectsChartData = []);

export const setDefaultColor = state => (state.defaultColor = defaultColor);
export const setNearObjectsColorSet = (state, nearObjectsColorSet) => {
    Vue.set(state, 'nearObjectsColorSet', nearObjectsColorSet);
};
export const clearNearObjectsColorSet = state => {
    Vue.set(state, 'nearObjectsColorSet', {});
};
export const setEmptyChartData = (state, empty) => (state.emptyChartData = empty);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
