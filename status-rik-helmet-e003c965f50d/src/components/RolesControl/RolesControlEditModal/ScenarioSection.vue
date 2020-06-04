<template>
    <q-card-section class="RolesControlEditModal-scenarioSection">
        <div class="RolesControlEditModal-title">Разрешения доступа</div>

        <q-scroll-area
            class="RolesControlEditModal-scenarioWrapScroll"
            :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }"
        >
            <ScenarioTree
                v-for="scenario in scenariosTree"
                :key="scenario.name"
                :scenario="scenario"
                @ticked="onTicked"
            />
        </q-scroll-area>
    </q-card-section>
</template>

<script>
import ScenarioTree from './ScenarioTree.vue';
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'ScenarioSection',
    components: {
        ScenarioTree
    },
    computed: {
        ...mapGetters('RolesControl', ['editRoleModalData', 'scenariosTree'])
    },
    methods: {
        ...mapMutations('RolesControl', ['setEditRoleModalData']),

        onTicked(payload) {
            let scenarios = [
                ...this.editRoleModalData.scenarios.filter(
                    scenario => scenario && scenario.rootName && scenario.rootName !== payload.rootName
                ),
                ...payload.scenarios
            ];

            this.setEditRoleModalData({ scenarios });
        }
    }
};
</script>

<style lang="sass">
.RolesControlEditModal
    &-scenarioSection
        padding: 0
        display: flex
        flex-direction: column
        flex-grow: 1
        overflow: hidden
    &-scenarioWrapScroll
        display: flex
        flex-direction: column
        flex-grow: 1
        overflow: hidden
        margin-top: 10px
        border: 1px solid rgba(0,0,0,0.24)
        border-radius: 4px
        padding: 14px
        padding-left: 0

        // Для того, чтобы содержимое q-scroll-area не схлопнулось в 0 по высоте,
        // потому что сам контент в ней размещается абсолютом,
        // нужно явно задать высоту, при этом, указанное такое большое значение не будет столько занимать по высоте,
        // а ограничится высотой контента, но на практике выяснил,
        // что значение высоты здесь должно быть больше фактической высоты контента
        & > .scroll
            height: 100000px !important
</style>
