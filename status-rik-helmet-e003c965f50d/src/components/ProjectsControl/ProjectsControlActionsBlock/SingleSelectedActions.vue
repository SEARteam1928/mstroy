<template>
    <div class="SingleSelectedActions">
        <q-btn
            class="SingleSelectedActions-editAccessBtn"
            unelevated
            outline
            label="Настройка доступа к проекту"
            color="ms-blue"
            @click="onEditAccessBtnClick"
        />
        <q-btn
            class="SingleSelectedActions-editProjectBtn"
            unelevated
            flat
            :label="editProjectBtnLabel"
            color="ms-primary"
            @click="onEditProjectBtnClick"
        />
        <q-btn
            class="SingleSelectedActions-deleteProjectBtn"
            unelevated
            flat
            :label="deleteProjectBtnLabel"
            color="ms-red"
            @click="onDeleteProjectBtnClick"
        />
    </div>
</template>

<script>
import withShowMessage from '@mixins/withShowMessage';
import isFalse from '@services/utils/isFalse';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'SingleSelectedActions',
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('ProjectsControl', ['selectedProjectsId']),
        ...mapGetters('Projects', ['getSelectedProject']),

        selectedProjectId() {
            return this.selectedProjectsId[0];
        },
        selectedProject() {
            let id = this.selectedProjectId;
            return this.getSelectedProject(id);
        },

        editProjectBtnLabel() {
            return this.isConfirmDeleteProject ? 'Подтвердить удаление' : 'Редактировать';
        },
        deleteProjectBtnLabel() {
            return this.isConfirmDeleteProject ? 'Отмена' : 'Удалить';
        }
    },
    watch: {
        // При переключении выбранного проекта будем сбрасывать режим ожидания удаления,
        // id ожидающий удаления и данные для редактирования проекта
        selectedProjectId() {
            this.isConfirmDeleteProject = false;
            this.clearDeleteProjectModalData();
            this.clearEditProjectModalData();
        }
    },
    data() {
        return {
            isConfirmDeleteProject: false
        };
    },
    methods: {
        ...mapMutations('ProjectsControl', [
            'setSelectedProjectsId',
            'setDeleteProjectModalData',
            'clearDeleteProjectModalData',
            'setEditProjectModalData',
            'setIsOpenEditProjectModal',
            'clearEditProjectModalData',
            'setEditAccessModalData',
            'setIsOpenEditAccessModal'
        ]),
        ...mapMutations('Projects', ['deleteProject']),
        ...mapActions('ProjectsControl', ['requestDeleteProject']),
        ...mapActions('Projects', ['requestAllProjects']),

        onAddChildrenGroupBtnClick() {
            this.setEditGroupModalData({ parentAccessGroupId: this.selectedGroupId });
            this.setIsOpenEditGroupModal(true);
        },
        // Кнопка редактирования работает в 2-х режимах:
        // 1. Естественный для нее режим - редактирования выбранного проекта
        // 2. Когда была нажата кнопка удаления, эта кнопка становится подтверждающей, и запускает сам процесс удаления
        onEditProjectBtnClick() {
            if (!this.isConfirmDeleteProject) {
                this.editProjectHandler();
            } else {
                this.deleteProjectHandler();
            }
        },
        editProjectHandler() {
            let {
                rowId: id,
                name,
                shortName,
                dateBegin,
                dateComplete,
                cost,
                timeZoneOffset,
                latitude,
                longitude,
                repoId,
                characteristics
            } = this.selectedProject;
            this.setEditProjectModalData({
                id,
                name,
                shortName,
                dateBegin,
                dateComplete,
                cost,
                timeZoneOffset,
                latitude,
                longitude,
                repoId,
                characteristics
            });
            this.setIsOpenEditProjectModal(true);
        },
        async deleteProjectHandler() {
            this.isConfirmDeleteProject = false;

            let { rowId: id, name } = this.selectedProject;
            this.setDeleteProjectModalData({ id });
            let res = await this.requestDeleteProject();

            // После запроса в любом случае очищаем id, ожидающий удаления
            this.clearDeleteProjectModalData();

            if (isFalse(res)) {
                this.showMessage(`Ошибка удаления проекта "${name}"`, true);
            } else {
                this.showMessage(`Проект "${name}" успешно удален`);

                // После успешного удаления снимаем выделение с удаленного проекта
                // и удаляем его из модуля хранилища Projects, откуда выводятся списки проектов для выбора в шапке
                // и в таблицу управления проектами
                this.setSelectedProjectsId([]);
                // this.deleteProject(id);
                this.requestAllProjects();
            }
        },
        onDeleteProjectBtnClick() {
            if (!this.isConfirmDeleteProject) {
                this.isConfirmDeleteProject = true;
                return;
            }

            this.isConfirmDeleteProject = false;
        },

        onEditAccessBtnClick() {
            let { rowId: projectId, shortName, name } = this.selectedProject;
            this.setEditAccessModalData({
                projectId,
                projectName: shortName || name
            });
            this.setIsOpenEditAccessModal(true);
        }
    }
};
</script>

<style lang="sass">
.SingleSelectedActions
    padding: 12px
    border-top: 1px solid var(--ms-grey)
    display: flex
    flex-wrap: wrap
    justify-content: space-between
    &-editAccessBtn
        width: 100%
        margin-bottom: 8px
</style>
