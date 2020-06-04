<template>
    <q-tree
        class="ScenarioTree"
        :nodes="nodes"
        node-key="name"
        label-key="description"
        tick-strategy="strict"
        :ticked.sync="ticked"
        :expanded.sync="expanded"
        @update:ticked="onTicked"
        ref="tree"
    />
</template>

<script>
import { mapGetters } from 'vuex';

export default {
    name: 'ScenarioTree',
    props: {
        scenario: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            nodes: [],
            expanded: [],
            ticked: [],

            tickedNodes: [],
            rootName: null
        };
    },
    computed: {
        ...mapGetters('RolesControl', ['editRoleModalData'])
    },
    created() {
        window.ScenarioTree = this;

        this.rootName = this.scenario.name;
        this.nodes.push({ ...this.scenario });

        this.restoreTickedState(this.nodes);
    },
    methods: {
        // Восстанавливает состояние отмеченных галочкой сценариев в соответствии с теми сценариями,
        // что лежат в хранилище для этой модалки
        restoreTickedState(scenarios) {
            if (!scenarios instanceof Array) return;

            // Проходит по сценариям этого компонента
            scenarios.forEach(scenario => {
                // Сравнивает имена с именами сценариев из хранилища
                let index = this.editRoleModalData.scenarios.findIndex(modalScenario => {
                    if (!modalScenario || !modalScenario.name) return false;
                    return modalScenario.name === scenario.name;
                });

                if (index > -1) {
                    this.ticked.push(scenario.name);

                    // Если родительский сценарий отмечен галочкой и у сценария есть вложенные дочерние сценарии,
                    // то рекурсивно проверим их
                    if (scenario.children instanceof Array && scenario.children.length > 0) {
                        this.restoreTickedState(scenario.children);
                    }
                }
            });

            // После восстановления состояния проверят, нужно ли раскрыть ветку сценария
            this.checkExpand(this.ticked);
        },

        checkExpand(tickedNames) {
            if (!tickedNames.includes(this.rootName)) {
                this.ticked = [];
            }

            this.expanded = tickedNames;
        },

        onTicked(tickedNames) {
            this.checkExpand(tickedNames);

            this.$nextTick(() => {
                this.tickedNodes = this.$refs.tree.getTickedNodes();

                let payload = {
                    rootName: this.rootName,
                    scenarios: this.tickedNodes
                };

                this.$emit('ticked', payload);
            });
        }
    }
};
</script>

<style lang="sass">
.ScenarioTree
    .q-tree__node-header-content
        padding-left: 4px
    .q-tree__arrow
        font-size: 16px

    // Когда название сценария занимает несколько строк, это выравнивает чекбокс и стрелку по верхнему краю названия
    // .q-tree__arrow, .q-tree__spinner
    //     align-self: flex-start
    //     margin-top: 6px
    // .q-checkbox
    //     align-self: flex-start
    //     margin-top: 3px
</style>
