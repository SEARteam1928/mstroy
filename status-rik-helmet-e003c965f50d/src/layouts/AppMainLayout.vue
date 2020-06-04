<template>
    <q-layout view="lHh lpR fFf" :style="`--header-height: ${headerHeight}px; --drawer-width: ${drawerWidth}px;`">
        <!-- Хедер -->
        <LayoutHeader />

        <!-- Левое меню -->
        <LeftMenu />

        <!-- Окно рабочей части приложения -->
        <q-page-container>
            <router-view />
        </q-page-container>
    </q-layout>
</template>

<script>
import LayoutHeader from '../components/AppMainLayout/LayoutHeader.vue';
import LeftMenu from '../components/AppMainLayout/LeftMenu.vue';

import withModuleErrors from '../mixins/withModuleErrors';

import { mapState, mapGetters, mapMutations } from 'vuex';
import Message from '@services/message';

export default {
    name: 'AppMainLayout',
    meta() {
        return {
            title: this.headerTitle,
            titleTemplate: title => `${title} - BIM-портал`
        };
    },
    components: {
        LayoutHeader,
        LeftMenu
    },
    mixins: [withModuleErrors('RfidController')],
    computed: {
        ...mapState('route', ['meta']),
        ...mapGetters('UI', ['drawerLeft', 'drawerWidth', 'headerHeight']),

        isShowToolbarTitle() {
            return this.$q.screen.gt.xs;
        },

        headerTitle() {
            return this.meta.headerTitle || '';
        }
    },
    data() {
        return {
            transparentPixel: 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'
        };
    },
    methods: {
        ...mapMutations('Scenarios', ['clearScenarios', 'addScenario']),
        ...mapMutations('UI', ['setDrawerLeft']),

        addScenarioToStore(scenario) {
            scenario.rootName = scenario.name;

            if (scenario.root && scenario.children instanceof Array) {
                scenario.children.forEach(child => (child.rootName = scenario.name));
            }

            this.addScenario(scenario);
        },

        // Рекурсивно проходит по всем роутам и собирает из них сценарии
        collectScenarios(routesArr) {
            if (!routesArr instanceof Array) return;

            routesArr.forEach(({ meta, children }) => {
                if (meta) {
                    let { scenarios } = meta;

                    // Если в meta есть поле scenarios и оно объект (или массив)
                    if (scenarios instanceof Object) {
                        // Если лежал массив сценариев, проходим по нему и по одному добавляем в хранилище
                        if (scenarios instanceof Array) {
                            scenarios.forEach(scenario => {
                                this.addScenarioToStore(scenario);
                            });

                            // Если лежал один объект сценария, то добавляем его сразу в хранилище
                        } else {
                            this.addScenarioToStore(scenarios);
                        }
                    }
                }

                // Если есть вложенные дочерние роуты, то отдадим их в рекурсивный вызов collectScenarios
                if (children && children instanceof Array && children.length > 0) {
                    this.collectScenarios(children);
                }
            });
        }
    },
    created() {
        window.ml = this;

        Message.showMessages();

        // TODO: Возможно, сбор сценариев из роутера лучше будет перенести либо на саму
        // страницу управления ролями/сценариями, либо вынести в boot-файл,
        // если сценарии будут еще где-то использоваться и появятся другие лейоуты

        // Обнуление списка сценариев в хранилище нужно для режима разработки,
        // потому что при обновлении компонента, собирающего сценарии, они начинают дублироваться
        this.clearScenarios();

        let routes = this.$router.options.routes;
        this.collectScenarios(routes);
    }
};
</script>

<style lang="sass"></style>
