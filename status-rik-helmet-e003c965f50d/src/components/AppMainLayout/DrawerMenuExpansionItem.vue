<template>
    <q-expansion-item
        v-if="hasRoutes"
        class="DrawerMenuExpansionItem drawer-menu-expansion"
        expand-separator
        default-opened
        :to="controlledTo"
    >
        <template v-slot:header>
            <q-item-section v-if="icon" avatar>
                <QIconCustom :name="icon" :size="20" :colors="{ primary: '#fff' }" />
            </q-item-section>

            <q-item-section class="non-selectable">
                {{ routeGroupName }}
            </q-item-section>

            <q-tooltip
                v-if="tooltip"
                transition-show="fade"
                transition-hide="fade"
                anchor="center right"
                self="center left"
                :offset="[8, 0]"
                content-class="bg-ms-dark"
            >
                {{ routeGroupName }}
            </q-tooltip>
        </template>

        <DrawerMenuItem
            v-for="route in allowedRoutes"
            :key="route.name"
            :label="route.meta && route.meta.headerTitle"
            :to="{ name: route.name }"
            exact
            :level="2"
        />
    </q-expansion-item>
</template>

<script>
import QIconCustom from '../common/QIconCustom.vue';
import DrawerMenuItem from './DrawerMenuItem.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'DrawerMenuExpansionItem',
    components: {
        QIconCustom,
        DrawerMenuItem
    },
    props: {
        routeGroup: {
            type: Array,
            required: true
        },
        routeGroupName: {
            type: String,
            required: true
        },
        icon: {
            type: String,
            required: true
        },
        tooltip: {
            type: [Boolean, String],
            required: false,
            default: false
        }
    },
    computed: {
        ...mapGetters('UI', ['miniState']),
        ...mapGetters('User', ['checkScenarios']),

        // Возвращает массив роутов, разрешенных сценариями пользователя
        allowedRoutes() {
            return this.routeGroup.filter(route => this.checkScenarios(this.getScenarioName(route)));
        },
        hasRoutes() {
            return this.allowedRoutes.length;
        },
        // В компактном режиме меню заголовок раскрывающейся группы будет служить ссылкой
        // на первую страницу из группы своих пунктов
        controlledTo() {
            let to = undefined;

            if (this.miniState && this.hasRoutes) {
                let firstRoute = this.allowedRoutes[0];
                to = { name: firstRoute.name };
            }

            return to;
        }
    },
    methods: {
        getScenarioName(route) {
            let { meta } = route;

            return meta.scenarios && meta.scenarios instanceof Array && meta.scenarios.length && meta.scenarios[0].name;
        }
    }
};
</script>
