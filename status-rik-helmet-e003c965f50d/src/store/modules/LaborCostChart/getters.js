import isFalse from '@services/utils/isFalse';

export const projectId = state => state.projectId;

export const periodDate = state => state.periodDate;
export const emptyPeriodDate = state => {
    let result = false;
    let { from, to } = state.periodDate;
    if (isFalse(from) || isFalse(to)) result = true;

    return result;
};

export const isLoading = state => state.isLoading;

export const nearObjectsMap = state => state.nearObjectsMap;

export const nearObjectsChartData = state => state.nearObjectsChartData;

export const defaultColor = state => state.defaultColor;
export const nearObjectsColorSet = state => state.nearObjectsColorSet;
export const emptyChartData = state => state.emptyChartData;

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
