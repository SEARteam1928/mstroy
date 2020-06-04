import Api from '@services/api';
import { buildLaborCostChartData } from '@services/dataConverter';

export const requestNearObjects = async ({ getters, commit }) => {
    let { periodDate, defaultColor, emptyPeriodDate } = getters;
    if (emptyPeriodDate) return;

    let { from, to } = periodDate;

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestNearObjects');
        commit('setEmptyChartData', false);
        commit('setIsLoading', true);

        let res = await Api.getNearObjects(from, to);
        let buildedData = buildLaborCostChartData(res.data, defaultColor);
        console.log('requestNearObjects -> buildedData', buildedData);

        commit('setNearObjectsMap', buildedData.map);
        commit('setNearObjectsColorSet', buildedData.colors);
        commit('setNearObjectsChartData', buildedData.data);

        if (buildedData.data.length === 0) {
            commit('setEmptyChartData', true);
        }

        return res.data;
    } catch (err) {
        commit('setError', {
            type: 'requestNearObjects',
            error: err
        });
    } finally {
        commit('setIsLoading', false);
    }
};
