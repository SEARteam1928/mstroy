import { sync } from 'vuex-router-sync';

export default ({ store, router }) => {
    return sync(store, router);
};
