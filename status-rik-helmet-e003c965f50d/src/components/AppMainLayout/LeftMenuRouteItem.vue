<template>
    <DrawerMenuItem
        v-if="route && hasAllowedRoutes"
        :label="routeGroupName"
        :icon="icon"
        :to="routeTo"
        :tooltip="tooltip"
        exact
    />

    <DrawerMenuExpansionItem
        v-else-if="routeGroup && hasAllowedRoutes"
        :routeGroup="routeGroup"
        :routeGroupName="routeGroupName"
        :icon="icon"
        :tooltip="tooltip"
    />
</template>

<script>
import DrawerMenuItem from './DrawerMenuItem.vue';
import DrawerMenuExpansionItem from './DrawerMenuExpansionItem.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'LeftMenuRouteItem',
    components: {
        DrawerMenuItem,
        DrawerMenuExpansionItem
    },
    props: {
        routeGroup: {
            validator: prop => prop instanceof Array || prop === undefined,
            required: true
        },
        route: {
            validator: prop => prop instanceof Array || prop === undefined,
            required: true
        },
        routeGroupName: {
            type: String,
            required: true
        },
        icon: {
            type: [Boolean, String],
            required: false
        },
        tooltip: {
            type: [Boolean, String],
            required: false,
            default: false
        }
    },
    computed: {
        ...mapGetters('User', ['checkScenarios']),

        // Возвращает массив роутов, разрешенных сценариями пользователя
        allowedRoutes() {
            let routeGroup = this.routeGroup || this.route;

            return routeGroup.filter(route => this.checkScenarios(this.getScenarioName(route)));
        },
        hasAllowedRoutes() {
            return this.allowedRoutes.length > 0;
        },
        routeTo() {
            if (!this.hasAllowedRoutes) return;

            return {
                name: this.allowedRoutes[0].name
            };
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
