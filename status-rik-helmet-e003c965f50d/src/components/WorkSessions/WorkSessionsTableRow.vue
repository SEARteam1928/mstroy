<template>
    <div class="WorkSessionsTableRow">
        <q-tree :nodes="nodes" node-key="label" @lazy-load="onLazyLoad" @update:expanded="onExpanded" ref="tree">
            <template v-slot:header-root="prop">
                {{ prop.node.label }}
                <span v-if="prop.node.noNodes" class="no-nodes-label">({{ prop.node.noNodesLabel }})</span>
                <span v-if="prop.node.error" class="error-label">({{ prop.node.errorLabel }})</span>
            </template>

            <template v-slot:default-header="prop">
                <div class="default-child-header">
                    <WorkSessionsTableRowNode :nodeData="prop.node" @click.native.stop />
                </div>
            </template>
        </q-tree>
    </div>
</template>

<script>
import Vue from 'vue';

import WorkSessionsTableRowNode from './WorkSessionsTableRowNode.vue';

import { mapGetters, mapActions } from 'vuex';

export default {
    name: 'WorkSessionsTableRow',
    components: {
        WorkSessionsTableRowNode
    },
    props: {
        deviceId: {
            type: Number,
            required: true
        },
        label: {
            type: String,
            required: true
        }
    },
    computed: {
        ...mapGetters('WorkSessions', ['workSessionsData', 'workSessionsDataById'])
    },
    watch: {
        workSessionsData(newData) {
            this.updateChildren();
        }
    },
    created() {
        !window.WorkSessionsTableRow && (window.WorkSessionsTableRow = this);

        this.updateChildren();
    },
    data() {
        return {
            nodes: [
                {
                    header: 'root',
                    label: this.label,
                    noNodes: false,
                    noNodesLabel: 'У этого устройства пока нет рабочих сессий',
                    error: false,
                    errorLabel: 'Ошибка получения данных',
                    deviceId: this.deviceId,
                    lazy: true,
                    children: []
                }
            ]
        };
    },
    methods: {
        ...mapActions('WorkSessions', ['requestWorkSessions']),

        updateChildren() {
            let children = this.workSessionsDataById(this.deviceId);
            this.nodes[0].children = children;

            return children;
        },

        async onLazyLoad(prop) {
            let { node, done, fail } = prop;

            node.error = false;
            node.noNodes = false;

            let res = await this.requestWorkSessions(node.deviceId);

            // Если нет ответа, то это ошибка при запросе
            if (!res) {
                node.error = true;
                fail();

                return;
            }

            // Если массив пустой, значит нет сессий у этого устройства
            if (res instanceof Array && !res.length) {
                node.noNodes = true;
                fail();

                return;
            }

            // Если получены данные сессий устройства
            if (res instanceof Array && res.length) {
                let children = this.updateChildren();
                done(children);
            }
        },
        onExpanded(prop) {
            console.log('onExpanded: ', prop);
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsTableRow
    min-height: 39px
    border-bottom: 1px solid #000
    .q-tree__children
        background-color: #f5f5f5
        padding-top: 3px
        .q-tree__node-header
            transition: background-color 250ms ease-out
            &:hover
                background-color: #e5e5e5
    .q-tree__node-header
        margin-top: 0
        padding: 8px 4px
    .q-tree__spinner
        width: 16px
        height: 21px
        padding: 1px
        box-sizing: border-box
    .default-child-header
        width: 100%

    .no-nodes-label, .error-label
        margin-left: 10px
</style>
