import state from './state';
import * as getters from './getters';
import * as mutations from './mutations';
import * as actions from './actions';

import withModuleErrors, { applyMixin } from '../../mixins/withModuleErrors';

let moduleData = applyMixin(withModuleErrors, {
    state,
    getters,
    mutations,
    actions
});

export default moduleData;
