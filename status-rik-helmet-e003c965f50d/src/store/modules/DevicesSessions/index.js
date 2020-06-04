import state from './state';
import * as getters from './getters';
import * as mutations from './mutations';
import * as actions from './actions';

import withProjectSwitch, { applyMixin } from '../../mixins/withProjectSwitch';
import withModuleErrors from '../../mixins/withModuleErrors';

let moduleData = applyMixin(withProjectSwitch, {
    state,
    getters,
    mutations,
    actions
});

moduleData = applyMixin(withModuleErrors, moduleData);

export default moduleData;
