import Api from '@services/api';

// dispatch
// Запрашивает список объектов
export const requestObjects = async ({ commit }) => {
    let result = [];

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestObjects');
        commit('clearObjects');

        let res = await Api.getObjects();
        result = res.data;

        commit('setObjects', result);
    } catch (err) {
        commit('setError', {
            type: 'requestObjects',
            error: err
        });
    }
};

// Запрашивает список координат точек, из которых состоят объекты
export const requestObjectsCoords = async ({ commit }) => {
    let result = [];

    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestObjectsCoords');
        commit('clearObjectsCoords');

        let res = await Api.getObjectsCoords();
        result = res.data;

        commit('setObjectsCoords', result);
    } catch (err) {
        commit('setError', {
            type: 'requestObjectsCoords',
            error: err
        });
    }
};

export const requestWorkZones = ({ dispatch }) => {
    dispatch('requestObjects');
    dispatch('requestObjectsCoords');
};
