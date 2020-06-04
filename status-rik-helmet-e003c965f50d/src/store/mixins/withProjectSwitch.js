import applyMixin from './applyMixin';

const state = {
    projectId: null
};

const getters = {
    projectId: state => state.projectId
};

const mutations = {
    setProjectId: (state, projectId) => (state.projectId = projectId)
};

export default {
    state,
    getters,
    mutations
};

export { applyMixin, state, getters, mutations };
