<template>
    <div class="ProjectElementsTree">
        <q-scroll-area
            class="ProjectElementsTree-scrollArea"
            :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }"
        >
            <q-tree
                class="ProjectElementsTree-tree"
                :nodes="allProjectElements"
                :selected.sync="selected"
                :expanded.sync="expanded"
                node-key="rowId"
                label-key="name"
                selected-color="ms-primary"
            />
        </q-scroll-area>
    </div>
</template>

<script>
import { colors as quasarColors } from 'quasar';
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'ProjectElementsTree',
    data() {
        return {
            selected: null,
            expanded: []
        };
    },
    computed: {
        ...mapGetters('Bim', ['allProjectElements', 'getProjectElement'])
    },
    watch: {
        selected(newSelected) {
            let selectedElement = this.getProjectElement(newSelected);
            selectedElement = selectedElement ? { ...selectedElement } : {};
            delete selectedElement.children;

            this.setSelectedProjectElement(selectedElement);
            let {
                rowId: constructiveId,
                name: constructiveName,
                code: constructiveCode,
                isComplete,
                measureUnit,
                constructiveVersions
            } = selectedElement;

            let appId = null;
            let volume = null;
            let cost = null;
            let versionStart = null;
            let versionFinish = null;

            if (constructiveVersions && constructiveVersions.length > 0) {
                appId = constructiveVersions[0].appId;
                volume = constructiveVersions[0].volume;
                cost = constructiveVersions[0].cost;
                versionStart = constructiveVersions[0].versionStart;
                versionFinish = constructiveVersions[0].versionFinish;
            }

            // Если выбирается пункт из конструктивов, значит данные selectedCompleteData нужно полностью очистить
            this.clearSelectedCompleteData();
            // и собирать новые
            this.setSelectedCompleteData({
                constructiveId,
                constructiveName,
                constructiveCode,
                isComplete,
                measureUnit,
                appId,
                volume,
                cost,
                versionStart,
                versionFinish
            });

            this.$emit('select', newSelected);
            this.$emit('selectElement', selectedElement);

            if (!newSelected) return;
            if (this.expanded.includes(newSelected)) return;

            this.expanded.push(newSelected);
        }
    },
    methods: {
        ...mapMutations('Bim', ['setSelectedProjectElement', 'clearSelectedCompleteData', 'setSelectedCompleteData'])
    }
};
</script>

<style lang="sass">
.ProjectElementsTree
    width: 350px
    overflow: hidden
    display: flex
    flex-direction: column
    background-color: #fff
    border-radius: 4px
    &-scrollArea
        flex-grow: 1
        height: 100%
    &-tree
        top: -3px

    .q-tree__node--selected
        background-color: var(--ms-light-grey)
</style>
