import Vue from 'vue';
import VueRouter from 'vue-router';
import { Notify } from 'quasar';

import routes from './routes';
import routeGuardBuilder, { noAuthGuard, authGuard, scenarioGuard } from './middleware';
const routeGuard = routeGuardBuilder([noAuthGuard, authGuard, scenarioGuard]);

import User from '@services/user';
import RfidReaderController from '@services/rfidReaderController';

Vue.use(VueRouter);

/*
 * If not building with SSR mode, you can
 * directly export the Router instantiation
 */

/* { store, ssrContext } */
export default function({ store }) {
    const Router = new VueRouter({
        scrollBehavior: () => ({
            x: 0,
            y: 0
        }),
        routes,

        // Leave these as is and change from quasar.conf.js instead!
        // quasar.conf.js -> build -> vueRouterMode
        // quasar.conf.js -> build -> publicPath
        mode: process.env.DEV ? 'history' : process.env.VUE_ROUTER_MODE,
        base: process.env.VUE_ROUTER_BASE
    });

    User.setRouter(Router).setStore(store);
    RfidReaderController.setRouter(Router).setStore(store);

    Router.beforeEach(async (to, from, next) => {
        // BUG: Отсюда может прилетать ошибка с графа при получении информации о юзере
        try {
            await User.getUserRequest;
        } catch (error) {
            if (process.env.DEV) {
                Notify.create({
                    icon: 'close',
                    color: 'btn_red',
                    message: String(error)
                });
            }
        }

        return routeGuard(to, from, next, store);
    });

    return Router;
}
