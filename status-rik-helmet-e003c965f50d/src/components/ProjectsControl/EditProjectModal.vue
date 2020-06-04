<template>
    <Modal
        contentClass="EditProjectModal"
        cardClass="EditProjectModal-card"
        v-model="isOpenEditProjectModalModel"
        persistent
        @hide="onModalHide"
        @show="onModalShow"
    >
        <template v-slot:title>
            <div class="EditProjectModal-title">
                {{ modalTitle }}
                <div v-if="projectName" class="EditProjectModal-titleName" :title="projectName">{{ projectName }}</div>
            </div>
        </template>

        <template v-slot:body>
            <!-- Секция "Название" -->
            <div class="EditProjectModal-section name">
                <div class="EditProjectModal-sectionLabel">Название</div>
                <div class="EditProjectModal-sectionAction">
                    <InputCustom
                        class="EditProjectModal-input"
                        type="text"
                        placeholder="Введите название проекта"
                        :value="editProjectModalData.name"
                        @input="onEditPropInput('name', $event)"
                        @keypress.enter="onInputKeypressEnter"
                        ref="input"
                    />
                </div>
            </div>

            <!-- Секция "Короткое название" -->
            <div class="EditProjectModal-section shortName">
                <div class="EditProjectModal-sectionLabel">Короткое название</div>
                <div class="EditProjectModal-sectionAction">
                    <InputCustom
                        class="EditProjectModal-input"
                        type="text"
                        placeholder="Введите название проекта"
                        :value="editProjectModalData.shortName"
                        @input="onEditPropInput('shortName', $event)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>

            <!-- Секция "Дата начала" -->
            <div class="EditProjectModal-section dateBegin">
                <div class="EditProjectModal-sectionLabel">Дата начала</div>
                <div class="EditProjectModal-sectionAction">
                    <PeriodDatepickerInput
                        class="EditProjectModal-input"
                        label="Введите дату начала проекта"
                        :from="editProjectModalData.dateBegin"
                        @input="onEditPropInput('dateBegin', $event.from)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>

            <!-- Секция "Дата окончания" -->
            <div class="EditProjectModal-section dateComplete">
                <div class="EditProjectModal-sectionLabel">Дата окончания</div>
                <div class="EditProjectModal-sectionAction">
                    <PeriodDatepickerInput
                        class="EditProjectModal-input"
                        label="Введите дату окончания проекта"
                        :from="editProjectModalData.dateComplete"
                        @input="onEditPropInput('dateComplete', $event.from)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>

            <!-- Секция "Стоимость проекта" -->
            <div class="EditProjectModal-section cost">
                <div class="EditProjectModal-sectionLabel">Стоимость проекта</div>
                <div class="EditProjectModal-sectionAction">
                    <InputCustom
                        class="EditProjectModal-input"
                        type="text"
                        placeholder="Введите стоимость проекта"
                        :value="editProjectModalData.cost"
                        @input="onEditPropInput('cost', $event)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>

            <!-- Секция "Смещение часового пояса" -->
            <div class="EditProjectModal-section timeZoneOffset">
                <div class="EditProjectModal-sectionLabel">Смещение часового пояса</div>
                <div class="EditProjectModal-sectionAction">
                    <InputCustom
                        class="EditProjectModal-input"
                        type="text"
                        placeholder="Введите смещение часового пояса в минутах"
                        :value="editProjectModalData.timeZoneOffset"
                        @input="onEditPropInput('timeZoneOffset', $event)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>

            <!-- Секция "Широта проекта" -->
            <div class="EditProjectModal-section latitude">
                <div class="EditProjectModal-sectionLabel">Широта проекта</div>
                <div class="EditProjectModal-sectionAction">
                    <InputCustom
                        class="EditProjectModal-input"
                        type="text"
                        placeholder="Введите широту проекта"
                        :value="editProjectModalData.latitude"
                        @input="onEditPropInput('latitude', $event)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>

            <!-- Секция "Долгота проекта" -->
            <div class="EditProjectModal-section longitude">
                <div class="EditProjectModal-sectionLabel">Долгота проекта</div>
                <div class="EditProjectModal-sectionAction">
                    <InputCustom
                        class="EditProjectModal-input"
                        type="text"
                        placeholder="Введите долготу проекта"
                        :value="editProjectModalData.longitude"
                        @input="onEditPropInput('longitude', $event)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>

            <!-- Секция "Репозиторий проекта" -->
            <div class="EditProjectModal-section repoId">
                <div class="EditProjectModal-sectionLabel">Репозиторий проекта</div>
                <div class="EditProjectModal-sectionAction">
                    <InputCustom
                        class="EditProjectModal-input"
                        type="text"
                        placeholder="Введите репозиторий проекта"
                        :value="editProjectModalData.repoId"
                        @input="onEditPropInput('repoId', $event)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>

            <!-- Секция "Технические характеристики" -->
            <div class="EditProjectModal-section characteristics">
                <div class="EditProjectModal-sectionLabel">Технические характеристики</div>
                <div class="EditProjectModal-sectionAction">
                    <TextareaCustom
                        class="EditProjectModal-input"
                        rows="3"
                        placeholder="Введите краткие технические характеристики"
                        :value="editProjectModalData.characteristics"
                        @input="onEditPropInput('characteristics', $event)"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>
        </template>

        <template v-slot:actions>
            <q-btn
                v-if="isCreateMode"
                class="EditProjectModal-addProjectBtn"
                unelevated
                label="Добавить проект"
                color="ms-primary"
                :disable="!modalDataReady"
                @click="onAddProjectBtnClick"
            />
            <q-btn
                v-if="!isCreateMode"
                class="EditProjectModal-editProjectBtn"
                unelevated
                label="Применить изменения"
                color="ms-primary"
                :disable="!modalDataReady"
                @click="onEditProjectBtnClick"
            />
        </template>
    </Modal>
</template>

<script>
import Modal from '@components/common/Modal.vue';
import InputCustom from '@components/common/InputCustom.vue';
import TextareaCustom from '@components/common/TextareaCustom.vue';
import PeriodDatepickerInput from '@components/common/PeriodDatepickerInput.vue';

import withShowMessage from '@mixins/withShowMessage';
import isFalse from '@services/utils/isFalse';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'EditProjectModal',
    components: {
        Modal,
        InputCustom,
        TextareaCustom,
        PeriodDatepickerInput
    },
    mixins: [withShowMessage()],
    data() {
        return {
            projectName: null
        };
    },
    computed: {
        ...mapGetters('ProjectsControl', ['isOpenEditProjectModal', 'editProjectModalData']),

        isOpenEditProjectModalModel: {
            get() {
                return this.isOpenEditProjectModal;
            },
            set(val) {
                this.setIsOpenEditProjectModal(!!val);
            }
        },

        isCreateMode() {
            return isFalse(this.editProjectModalData.id);
        },
        modalTitle() {
            return this.isCreateMode ? 'Добавление проекта' : 'Редактирование проекта';
        },
        hasName() {
            return (
                this.editProjectModalData?.name?.trim().length > 0 ||
                this.editProjectModalData?.shortName?.trim().length > 0
            );
        },
        modalDataReady() {
            return (
                this.editProjectModalData?.name?.trim().length > 0 &&
                this.editProjectModalData?.shortName?.trim().length > 0
            );
        }
    },
    methods: {
        ...mapMutations('ProjectsControl', [
            'setIsOpenEditProjectModal',
            'setEditProjectModalData',
            'clearEditProjectModalData'
        ]),
        ...mapMutations('Projects', ['addProject', 'updateProject']),
        ...mapActions('ProjectsControl', ['requestCreateProject', 'requestEditProject']),
        ...mapActions('Projects', ['requestAllProjects']),

        onModalHide() {
            this.clearEditProjectModalData();
        },
        onModalShow() {
            if (this.hasName) {
                this.projectName = this.editProjectModalData?.shortName || this.editProjectModalData?.name;
            } else {
                this.projectName = null;
            }

            this.$refs?.input?.focus();
        },

        onInputKeypressEnter() {
            if (!this.modalDataReady) return;

            this.isCreateMode ? this.onAddProjectBtnClick() : this.onEditProjectBtnClick();
        },

        onEditPropInput(propName, value) {
            this.setEditProjectModalData({ [propName]: value });
        },

        async onAddProjectBtnClick() {
            let createdProject = await this.requestCreateProject();

            if (isFalse(createdProject)) {
                this.showMessage('Ошибка добавления проекта', true);
            } else {
                // this.addLocalProject(createdProject);
                this.requestAllProjects();
                this.showMessage('Проект успешно добавлен');
                this.setIsOpenEditProjectModal(false);
            }
        },
        async onEditProjectBtnClick() {
            let updatedProject = await this.requestEditProject();

            if (isFalse(updatedProject)) {
                this.showMessage('Ошибка редактирования проекта', true);
            } else {
                // this.updateLocalProject(updatedProject);
                this.requestAllProjects();
                this.showMessage('Проект успешно изменен');
                this.setIsOpenEditProjectModal(false);
            }
        },

        addLocalProject(createdProject) {
            let newProjectData = { ...createdProject };
            newProjectData.value = createdProject.rowId;
            newProjectData.label = createdProject.shortName || createdProject.name;

            this.addProject(newProjectData);
        },

        updateLocalProject(updatedProject) {
            let newProjectData = { ...updatedProject };
            newProjectData.value = updatedProject.rowId;
            newProjectData.label = updatedProject.shortName || updatedProject.name;

            this.updateProject(newProjectData);
        }
    }
};
</script>

<style lang="sass">
.EditProjectModal
    &-card
        min-width: 600px
    &-title
        margin-top: -6px
    &-titleName
        font-weight: bold
        overflow: hidden
        display: -webkit-box
        -webkit-box-orient: vertical
        -webkit-line-clamp: 2
    &-section
        display: flex
        align-items: center
        padding-bottom: 16px
    &-sectionLabel
        width: 100%
        max-width: 116px
        font-weight: bold
        line-height: 20px
        margin-right: 8px
    &-sectionAction
        width: 100%
        flex-grow: 1
    &-input
        .q-field__label
            color: var(--ms-grey)
        .q-field__native
            color: var(--ms-dark)
        .q-field__control:before
            border-color: var(--ms-grey)
        .q-icon
            color: var(--ms-grey)
            transition: color 250ms ease-in-out
            &:hover
                color: var(--ms-dark)

    &-addProjectBtn,
    &-editProjectBtn
        padding: 0 16px

    .Modal
        &-body
            padding-bottom: 0
</style>
