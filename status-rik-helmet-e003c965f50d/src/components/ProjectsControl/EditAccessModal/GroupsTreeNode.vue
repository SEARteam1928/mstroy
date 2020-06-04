<template>
    <div class="GroupsTreeNode">
        <div class="GroupsTreeNode-label">{{ label }}</div>
        <div
            class="GroupsTreeNode-actions"
            :class="{ 'GroupsTreeNode-actionsDisable': !hasProjectAccessRulesId }"
            :title="!hasProjectAccessRulesId ? 'Данные о разрешениях доступа не загружены' : ''"
            @click.prevent.stop
        >
            <q-checkbox
                class="GroupsTreeNode-checkbox"
                :class="{ 'GroupsTreeNode-checkboxWait': optimisticRead }"
                dense
                keep-color
                :color="checkboxReadModel && !optimisticRead ? 'ms-primary' : 'ms-grey'"
                v-model="checkboxReadModel"
                :title="checkboxReadTitle"
                :disable="!hasProjectAccessRulesId || optimisticRead"
            />
            <q-checkbox
                class="GroupsTreeNode-checkbox"
                :class="{ 'GroupsTreeNode-checkboxWait': optimisticUpdate }"
                dense
                keep-color
                :color="checkboxUpdateModel && !optimisticUpdate ? 'ms-primary' : 'ms-grey'"
                v-model="checkboxUpdateModel"
                :title="checkboxUpdateTitle"
                :disable="!checkboxReadModel || optimisticUpdate"
            />
            <q-checkbox
                class="GroupsTreeNode-checkbox"
                :class="{ 'GroupsTreeNode-checkboxWait': optimisticDelete }"
                dense
                keep-color
                :color="checkboxDeleteModel && !optimisticDelete ? 'ms-primary' : 'ms-grey'"
                v-model="checkboxDeleteModel"
                :title="checkboxDeleteTitle"
                :disable="!checkboxReadModel || optimisticDelete"
            />
        </div>
    </div>
</template>

<script>
import isFalse from '@services/utils/isFalse';

import withShowMessage from '@mixins/withShowMessage';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'GroupsTreeNode',
    mixins: [withShowMessage()],
    props: {
        prop: {
            type: Object,
            required: true
        },
        labelKey: {
            type: String,
            required: false,
            default: 'label'
        },
        optimisticAccessRules: {
            type: Object,
            required: false,
            default: () => {}
        }
    },
    computed: {
        ...mapGetters('ProjectsControl', ['editAccessModalData']),

        accessGroup() {
            return this.prop.node;
        },
        label() {
            return this.accessGroup[this.labelKey];
        },
        accessGroupRuleIds() {
            return this.accessGroup.ruleIds;
        },
        projectAccessRulesId() {
            return this.editAccessModalData.projectAccessRulesId;
        },
        hasProjectAccessRulesId() {
            let { readId, updateId, deleteId } = this.projectAccessRulesId;
            return !isFalse(readId) && !isFalse(updateId) && !isFalse(deleteId);
        },
        optimisticRead() {
            return this.hasTempRule('read');
        },
        checkboxReadModel: {
            get() {
                return this.optimisticRead || this.checkRule('read');
            },
            set(val) {
                if (this.optimisticRead) return;

                val = !!val;
                if (val) {
                    this.changeAccessRules({ read: true }, true);
                } else {
                    this.changeAccessRules({ read: true, update: true, delete: true }, false);
                }
            }
        },
        checkboxReadTitle() {
            let title = 'Доступ к проекту';
            title += this.optimisticRead ? ' (ожидается применение действия)' : '';

            return title;
        },
        optimisticUpdate() {
            return this.hasTempRule('update');
        },
        checkboxUpdateModel: {
            get() {
                return this.optimisticUpdate || this.checkRule('update');
            },
            set(val) {
                if (this.optimisticUpdate) return;

                val = !!val;
                this.changeAccessRules({ update: true }, val);
            }
        },
        checkboxUpdateTitle() {
            let title = 'Редактирование проекта';
            title += this.checkboxReadModel ? '' : ' (требуется разрешение на доступ)';
            title += this.optimisticUpdate ? ' (ожидается применение действия)' : '';

            return title;
        },
        optimisticDelete() {
            return this.hasTempRule('delete');
        },
        checkboxDeleteModel: {
            get() {
                return this.optimisticDelete || this.checkRule('delete');
            },
            set(val) {
                if (this.optimisticDelete) return;

                val = !!val;
                this.changeAccessRules({ delete: true }, val);
            }
        },
        checkboxDeleteTitle() {
            let title = 'Удаление проекта';
            title += this.checkboxReadModel ? '' : ' (требуется разрешение на доступ)';
            title += this.optimisticDelete ? ' (ожидается применение действия)' : '';

            return title;
        }
    },
    methods: {
        ...mapMutations('GroupsControl', ['updateAccessGroup']),
        ...mapActions('GroupsControl', ['requestAllAccessGroups', 'requestUpdateAccessGroup']),

        // Принимает тип доступа, возвращает id AccessRule для соответствующего типа доступа
        getRuleId(access) {
            let rulePropName = `${access}Id`;
            let ruleId = this.projectAccessRulesId[rulePropName];

            return ruleId;
        },
        // Проверяет, есть ли у группы доступ указанного типа к проекту
        checkRule(access) {
            let ruleId = this.getRuleId(access);
            if (isFalse(ruleId)) return false;

            return this.accessGroupRuleIds.includes(ruleId);
        },
        hasTempRule(access) {
            let ruleId = this.getRuleId(access);
            if (isFalse(ruleId)) return false;

            return this.optimisticAccessRules[ruleId] !== undefined;
        },
        // Проверяет, есть ли у группы правило доступа указанного типа к проекту, ожидающее применения на сервере
        checkTempRule(access) {
            let ruleId = this.getRuleId(access);
            if (isFalse(ruleId)) return false;

            return this.optimisticAccessRules[ruleId];
        },

        changeAccessRules(access, addAccessRules = true) {
            let task = { groupId: this.accessGroup.rowId, accessRules: {} };

            for (let accessType in access) {
                // Получаем id AccessRule для каждого типа доступа
                let ruleId = this.getRuleId(accessType);
                if (isFalse(ruleId)) continue;

                // Собираем accessRules таска, где ключ - ruleId, со значением true/false
                // Если значение true - ruleId добавляется в группу, иначе - убирается
                task.accessRules[ruleId] = addAccessRules;
            }

            this.$emit('changeAccessRules', task);
        }
    }
};
</script>

<style lang="sass">
.GroupsTreeNode
    min-width: 100px
    width: 100%
    color: var(--ms-dark)
    display: flex
    align-items: center
    justify-content: space-between
    position: relative
    &-actions
        padding: 0 8px
        min-width: 90px
        display: flex
        justify-content: space-between
    &-checkbox
        &.disabled
            opacity: 0.5 !important
    &-checkboxWait
        opacity: 1 !important
        cursor: default !important
        &.disabled
            opacity: 1 !important
    &-actionsDisable
        opacity: 0.3
        .GroupsTreeNode-checkbox
            pointer-events: none
</style>
