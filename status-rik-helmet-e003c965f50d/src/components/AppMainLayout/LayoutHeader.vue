<template>
    <q-header v-if="isShowHeader" class="LayoutHeader page-background text-ms-dark" :height-hint="headerHeight">
        <q-toolbar class="LayoutHeader-toolbar">
            <PortalTarget class="LayoutHeader-PortalTargetProjects" name="LayoutHeaderProjects"></PortalTarget>
            <Portal :to="portalForHeaderProjectItem">
                <HeaderProjectItem class="HeaderProjectItem" />
            </Portal>

            <HeaderTabs class="HeaderTabs" />
        </q-toolbar>
    </q-header>
</template>

<script>
import HeaderProjectItem from './HeaderProjectItem.vue';
import HeaderTabs from './HeaderTabs.vue';

import isFalse from '@services/utils/isFalse';

import { mapState, mapGetters, mapMutations } from 'vuex';

export default {
    name: 'LayoutHeader',
    components: {
        HeaderProjectItem,
        HeaderTabs
    },
    data() {
        return {
            defaultHeaderHeight: 68
        };
    },
    computed: {
        ...mapState('route', ['meta']),
        ...mapGetters('UI', ['headerHeight', 'isShowHeader', 'portalForHeaderProjectItem'])
    },
    watch: {
        meta: {
            handler(newMeta) {
                let { isNotShowHeader } = newMeta;
                this.setIsShowHeader(!isNotShowHeader);
            },
            deep: true,
            immediate: true
        },
        isShowHeader: {
            handler(newIsShowHeader) {
                if (isFalse(newIsShowHeader)) {
                    this.setHeaderHeight(0);
                } else {
                    this.setHeaderHeight(this.defaultHeaderHeight);
                }
            },
            immediate: true
        }
    },
    methods: {
        ...mapMutations('UI', ['setHeaderHeight', 'setIsShowHeader'])
    }
};
</script>

<style lang="sass">
.LayoutHeader
    &-toolbar
        height: var(--header-height)
        min-height: var(--header-height)
        padding: 0
        display: flex
    .q-layout__shadow:after
        box-shadow: none

    &-PortalTargetProjects
        height: 100%

    .HeaderProjectItem
        width: 350px
        min-width: 350px
        height: calc(100% - 6px)
        margin:
            top: 6px
            right: 0
            bottom: 0
            left: 8px
</style>
