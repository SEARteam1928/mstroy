<template>
    <div class="HeaderTabs page-block">
        <q-tabs class="HeaderTabs-tabs" align="left" stretch no-caps>
            <q-route-tab
                class="HeaderTabs-tab"
                v-for="tab in tabs"
                :key="tab.name"
                :to="{ name: tab.name || tab.path }"
                :label="tab.title"
                exact
            />
        </q-tabs>

        <PortalTarget class="HeaderTabs-PortalTarget" name="HeaderTabs"></PortalTarget>
    </div>
</template>

<script>
import isFalse from '../../services/utils/isFalse';

import { mapState, mapGetters } from 'vuex';

export default {
    name: 'HeaderTabs',
    computed: {
        ...mapState('route', ['meta']),
        ...mapGetters('User', ['checkScenarios']),

        tabs() {
            let tabs = [];

            if (this.meta.group instanceof Array) {
                tabs = this.meta.group.filter(({ scenario }) => isFalse(scenario) || this.checkScenarios(scenario));
            }

            return tabs;
        }
    }
};
</script>

<style lang="sass">
.HeaderTabs
    height: calc(100% - 6px)
    flex-grow: 1
    display: flex
    align-items: flex-end
    overflow: hidden
    margin:
        top: 6px
        right: 8px
        bottom: 0
        left: 8px
    &-tabs
        max-width: 100%
        color: var(--ms-dark)
    &-tab
        .q-tab__content,
        .q-tab__content
            min-width: auto
        &.q-tab--active
            .q-tab__indicator
                height: 3px
        .q-tab__label
    &-PortalTarget
        align-self: stretch
        width: 100%

    .q-tabs__arrow
        &:before
            content: ''
            position: absolute
            top: 0
            bottom: 0
            left: 0
            right: 0
            background-color: var(--ms-dark)
            opacity: 0
            transition: opacity 250ms ease-in-out
        &:hover
            &:before
                opacity: 0.1

    .q-tabs__arrow--left
        background: linear-gradient(90deg, rgba(255,255,255,1) 0%, rgba(255,255,255,0) 100%)
    .q-tabs__arrow--right
        background: linear-gradient(90deg, rgba(255,255,255,0) 0%, rgba(255,255,255,1) 100%)
</style>
