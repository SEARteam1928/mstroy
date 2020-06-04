import Api from '@services/api';

// Запрос списка всех проектов
export const requestAllProjects = async ({ commit }) => {
    try {
        // Очистка ошибки и данных перед новым запросом
        commit('clearError', 'requestAllProjects');
        commit('clearAllProjects');
        commit('setIsLoadingProjects', true);

        let result = await Api.allProjects();
        let allProjects = result.data.allProjects;
        let allProjectsMap = {};
        allProjects = allProjects.map((project, index) => {
            let { rowId, name } = project;
            allProjectsMap[rowId] = index;

            return {
                ...project,
                label: name,
                value: rowId
            };
        });

        commit('setAllProjects', allProjects);
        commit('setAllProjectsMap', allProjectsMap);
    } catch (err) {
        commit('setError', {
            type: 'requestAllProjects',
            error: err
        });
    } finally {
        commit('setIsLoadingProjects', false);
    }
};
