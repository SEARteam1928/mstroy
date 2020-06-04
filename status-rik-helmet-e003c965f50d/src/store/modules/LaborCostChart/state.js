export default {
    projectId: null,

    periodDate: {
        from: null,
        to: null
    },

    // Флаг, отмечающий загрузку данных, нужен для прелоадера
    isLoading: false,

    nearObjectsMap: {},
    nearObjectsChartData: [],
    defaultColor: '#f55f74',
    nearObjectsColorSet: {},
    emptyChartData: false,

    moduleErrors: {
        requestNearObjects: false
    }
};
