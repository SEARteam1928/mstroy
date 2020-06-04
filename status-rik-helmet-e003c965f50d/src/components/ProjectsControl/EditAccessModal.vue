<template>
    <Modal
        contentClass="EditAccessModal"
        cardClass="EditAccessModal-card"
        v-model="isOpenEditAccessModalModel"
        persistent
        :persistentBtn="persistentBtn"
        @show="onModalShow"
        @hide="onModalHide"
        ref="modal"
    >
        <template v-slot:title>
            <div class="EditAccessModal-title">
                Доступ групп к проекту
                <div v-if="projectName" class="EditAccessModal-titleName" :title="projectName">{{ projectName }}</div>
            </div>
        </template>

        <template v-slot:body>
            <GroupsTree
                class="EditAccessModal-GroupsTree"
                :treeData="groupsTreeData"
                :duration="expandDuration"
                @expanded="onGroupsTreeExpanded"
            />
        </template>
    </Modal>
</template>

<script>
import Modal from '@components/common/Modal.vue';
import GroupsTree from './EditAccessModal/GroupsTree.vue';

import withShowMessage from '@mixins/withShowMessage';
import isFalse from '@services/utils/isFalse';
import delay from '@services/utils/delay';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'EditAccessModal',
    components: {
        Modal,
        GroupsTree
    },
    mixins: [withShowMessage()],
    data() {
        return {
            expandDuration: 150
        };
    },
    computed: {
        ...mapGetters('ProjectsControl', ['isOpenEditAccessModal', 'editAccessModalData']),
        ...mapGetters('Projects', ['getSelectedProject']),
        ...mapGetters('GroupsControl', ['allAccessGroupsTree']),

        selectedProjectId() {
            return this.editAccessModalData.projectId;
        },
        selectedProject() {
            return this.getSelectedProject(this.selectedProjectId);
        },
        projectName() {
            return this.editAccessModalData.projectName;
        },
        persistentBtn() {
            return this.editAccessModalData.persistent;
        },

        hasGroupsTreeData() {
            return this.allAccessGroupsTree.length > 0;
        },
        groupsTreeData() {
            return this.allAccessGroupsTree;
        },

        isOpenEditAccessModalModel: {
            get() {
                return this.isOpenEditAccessModal;
            },
            set(val) {
                this.setIsOpenEditAccessModal(!!val);
            }
        }
    },
    methods: {
        ...mapMutations('ProjectsControl', [
            'setIsOpenEditAccessModal',
            'setEditAccessModalData',
            'clearEditAccessModalData'
        ]),
        ...mapActions('ProjectsControl', ['requestProjectAccessRules', 'requestCreateAccessRuleForNewProject']),

        async getProjectAccessRulesId() {
            let projectAccessRulesId = await this.requestProjectAccessRules(this.selectedProjectId);
            if (isFalse(projectAccessRulesId)) {
                let errorMsg = `Ошибка получения информации о правах доступа для проекта "${this.projectName}"`;
                this.showMessage(errorMsg, true);
                return;
            }

            return projectAccessRulesId;
        },

        async onModalShow() {
            let projectName = this.projectName;
            let projectAccessRulesId = await this.getProjectAccessRulesId();
            if (isFalse(projectAccessRulesId)) return;

            let { readId, updateId, deleteId } = projectAccessRulesId;
            let withRead = isFalse(readId);
            let withUpdate = isFalse(updateId);
            let withDelete = isFalse(deleteId);
            if (withRead || withUpdate || withDelete) {
                let needCreateAccessRules = { withRead, withUpdate, withDelete };
                let newProjectAccessRulesId = await this.requestCreateAccessRuleForNewProject({
                    projectId: this.selectedProjectId,
                    projectName,
                    withRead,
                    withUpdate,
                    withDelete
                });

                if (!isFalse(newProjectAccessRulesId.readId)) {
                    projectAccessRulesId.readId = newProjectAccessRulesId.readId;
                }
                if (!isFalse(newProjectAccessRulesId.updateId)) {
                    projectAccessRulesId.updateId = newProjectAccessRulesId.updateId;
                }
                if (!isFalse(newProjectAccessRulesId.deleteId)) {
                    projectAccessRulesId.deleteId = newProjectAccessRulesId.deleteId;
                }
            }

            if (isFalse(projectAccessRulesId)) {
                this.isOpenEditAccessModalModel = false;
                return;
            }

            this.setEditAccessModalData({ projectAccessRulesId });
        },
        onModalHide() {
            this.clearEditAccessModalData();
        },

        onGroupsTreeExpanded() {
            delay(this.expandDuration + 100).then(this.$refs.modal.calcBodySize);
        }
    }
};
</script>

<style lang="sass">
.EditAccessModal
    &-card
        min-width: 650px
        height: 500px
    &-title
        margin-top: -6px
    &-titleName
        font-weight: bold
        overflow: hidden
        display: -webkit-box
        -webkit-box-orient: vertical
        -webkit-line-clamp: 2
</style>
