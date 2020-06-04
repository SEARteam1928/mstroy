import applyMixin from './applyMixin';

const state = {
    moduleErrors: {}
};

const getters = {
    moduleErrors: state => {
        let errors = {};
        Object.keys(state.moduleErrors).forEach(err => {
            let error = state.moduleErrors[err];
            if (error) errors[err] = error;
        });

        return errors;
    },
    showErrors: (_, getters) => {
        return JSON.stringify(getters.moduleErrors, ' ', 4);
    }
};

const mutations = {
    setError: (state, errorData) => {
        let { type, error } = errorData;
        state.moduleErrors[type] = error;
    },
    clearError: (state, errorType) => {
        state.moduleErrors[errorType] = false;
    }
};

export default {
    state,
    getters,
    mutations
};

export { applyMixin, state, getters, mutations };
