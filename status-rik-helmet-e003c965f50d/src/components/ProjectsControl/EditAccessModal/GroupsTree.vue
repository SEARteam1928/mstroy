<template>
    <div class="GroupsTree">
        <q-tree
            class="GroupsTree-tree"
            :nodes="treeData"
            :expanded.sync="expanded"
            :duration="duration"
            node-key="rowId"
            selected-color="ms-dark"
        >
            <template v-slot:default-header="prop">
                <GroupsTreeNode
                    class="GroupsTreeNode"
                    :prop="prop"
                    :optimisticAccessRules="optimisticGroupsAccessRules[prop.key] || {}"
                    labelKey="name"
                    @changeAccessRules="onChangeAccessRules"
                />
            </template>
        </q-tree>
    </div>
</template>

<script>
import GroupsTreeNode from './GroupsTreeNode.vue';

import withShowMessage from '@mixins/withShowMessage';
import isFalse from '@services/utils/isFalse';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'GroupsTree',
    components: {
        GroupsTreeNode
    },
    mixins: [withShowMessage()],
    props: {
        treeData: {
            type: Array,
            required: true
        },
        duration: {
            type: Number,
            required: false,
            default: 300
        }
    },
    data() {
        return {
            expanded: [],
            queueChangesGroupsAccessRules: [],
            currentQueueTask: {},
            queueChangesExecutorRunning: false
        };
    },
    computed: {
        ...mapGetters('GroupsControl', ['getGroupById']),

        optimisticGroupsAccessRules() {
            let result = {};

            // Циклом по запланированным таскам и по текущему собираем объект
            // оптимистичных результатов изменений AccessRules для групп вида:
            // { groupId: {accessRuleId: true/false} }
            // Если значение accessRuleId true - будем добавлять accessRuleId к существующим ранее у группы,
            // иначе - убираем этот accessRuleId из массива AccessRules, у группы
            [...this.queueChangesGroupsAccessRules, this.currentQueueTask].forEach(({ groupId, accessRules }) => {
                result[groupId] = { ...result[groupId], ...accessRules };
            });

            return result;
        },
        hasQueueTasks() {
            return this.queueChangesGroupsAccessRules.length > 0;
        }
    },
    watch: {
        expanded(newExpanded) {
            this.$emit('expanded', newExpanded);
        },
        hasQueueTasks(newHasQueueTasks) {
            this.setEditAccessModalData({ persistent: newHasQueueTasks });
        }
    },
    methods: {
        ...mapMutations('ProjectsControl', ['setEditAccessModalData']),
        ...mapActions('GroupsControl', ['requestUpdateAccessGroup']),

        onChangeAccessRules(task) {
            this.queueChangesGroupsAccessRules.push(task);
            this.queueChangesExecutor();
        },

        async queueChangesExecutor() {
            // Если процесс исполнения очереди уже запущен, то выходим и ничего не будем делать,
            // он сам будет вызываться рекурсивно, пока есть элементы в очереди
            if (this.queueChangesExecutorRunning) return;

            let firstTask = this.queueChangesGroupsAccessRules.shift();
            // Если элементы в очереди закончились, просто выходим,
            // очистка данных уже произошла в конце прошлого вызова
            if (!firstTask) return;

            this.queueChangesExecutorRunning = true;
            this.currentQueueTask = firstTask;

            await this.acceptChangesAccessRule(firstTask);

            // После применения изменений(удачного или нет) очищаем данные
            // для следующего рекурсивного запуска queueChangesExecutor
            this.currentQueueTask = {};
            this.queueChangesExecutorRunning = false;

            // Рекурсивный запуск исполнителя очереди, если очередь уже закончена, он сам завершит рекурсию
            this.queueChangesExecutor();
        },

        async acceptChangesAccessRule(task) {
            let { groupId, accessRules: accessRulesFromTask } = task;
            // Получаем полные данные группы из таска
            let groupOfTask = this.getGroupById(groupId);
            if (!groupOfTask) return;

            let { rowId: id, name, ruleIds } = groupOfTask;

            // Применяем к набору id AccessRules группы изменения, объявленные в таске
            let newAccessRulesSet = new Set(ruleIds);
            for (let accessRuleId in accessRulesFromTask) {
                if (accessRulesFromTask[accessRuleId]) {
                    newAccessRulesSet.add(+accessRuleId);
                } else {
                    newAccessRulesSet.delete(+accessRuleId);
                }
            }

            // Собираем данные для обновления группы
            let newGroupData = { id, ruleIds: [...newAccessRulesSet] };
            let res = await this.requestUpdateAccessGroup(newGroupData);

            // Если requestUpdateAccessGroup ничего не вернул,
            // значит запрос упал с ошибкой, которая была перехвачена в хранилище
            if (isFalse(res)) {
                this.showMessage(`Ошибка изменения прав доступа для группы "${name}"`, true);
            }
        }
    }
};
</script>

<style lang="sass">
.GroupsTree
    .q-tree__node
        // Цвет палочек-направляющих у раскрывающихся айтемов
        &:after
            border-color: var(--ms-grey)
    .q-tree__node-header
        cursor: default
        // Цвет палочек-направляющих у раскрывающихся айтемов
        &:before
            border-color: var(--ms-grey)
        &:hover
            background-color: var(--ms-light-grey)
        &.q-tree__node--link
            cursor: pointer
        & > .q-focus-helper
            background-color: var(--ms-light-grey)
            color: var(--ms-dark)

        // Цвет иконок со стрелками у раскрывающихся айтемов
        & > .q-tree__arrow
            color: var(--ms-grey)
</style>
