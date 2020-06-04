<template>
    <q-page class="Bim-page page-background">
        <div class="Bim">
            <Portal to="HeaderTabs">
                <BimHeader class="BimHeader" />
            </Portal>

            <div class="Bim-mainContent">
                <div class="Bim-BimViewWrap shadow-2">
                    <BimView class="BimView" :bim-server-client="bimServerClient" />

                    <!-- <ProjectElementDataView /> -->
                </div>
            </div>
        </div>
    </q-page>
</template>

<script>
import BimHeader from '../components/bim/BimHeader.vue';
import ProjectElementsTree from '../components/bim/ProjectElementsTree.vue';
import ProjectElementDataView from '../components/bim/ProjectElementDataView.vue';
import BimView from '../components/bim/BimView.vue';

import { BimServerClient } from 'bimserverapi';
import withShowMessage from '@mixins/withShowMessage';
import withProjectSwitch from '@mixins/withProjectSwitch';
import withModuleErrors from '@mixins/withModuleErrors';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'Bim',
    components: {
        BimHeader,
        ProjectElementsTree,
        ProjectElementDataView,
        BimView
    },
    mixins: [withShowMessage(), withProjectSwitch('Bim'), withModuleErrors('Bim')],
    data() {
        return {
            bimServerUrl: process.env.BIM_SERVER_URL,
            bimServerUsername: 'admin@example.com',
            bimServerPassword: 'admin',
            bimServerClient: null
        };
    },
    computed: {
        ...mapGetters('Bim', ['projectsRequested', 'selectedProject', 'moduleErrors'])
    },
    created() {
        this.bimServerClient = new BimServerClient(this.bimServerUrl);
    },
    mounted() {
        this.setProjectsRequested(true);

        const bimServerClient = this.bimServerClient;
        bimServerClient.init().then(
            () => {
                bimServerClient.login(
                    this.bimServerUsername,
                    this.bimServerPassword,
                    () => {
                        bimServerClient.call(
                            'ServiceInterface',
                            'getAllProjects',
                            {
                                onlyTopLevel: true,
                                onlyActive: true
                            },
                            projects => this.projectsRequestedSuccess(projects),
                            error => this.projectsRequestedError('Не удалось получить список проектов', error)
                        );
                    },
                    () => this.projectsRequestedError('Не удалось авторизоваться на BIMServer')
                );
            },
            () => this.projectsRequestedError('Не удалось подключиться к BIMServer. Обратитесь к администратору')
        );
    },
    methods: {
        ...mapMutations('Bim', [
            'setProjectsRequested',
            'setProjects',
            'setError',
            'clearError',
            'setActualTransactionId'
        ]),
        ...mapActions('Bim', ['requestAllProjectElements']),

        projectSwitchProject(newProject) {
            if (!newProject) return;

            let { actualProjectTransactionId } = newProject;
            this.setActualTransactionId(actualProjectTransactionId);
            this.requestAllProjectElements();
        },
        projectsRequestedSuccess(projects) {
            this.setProjects(projects);
            this.setProjectsRequested(false);
        },
        projectsRequestedError(msg, error) {
            this.setProjectsRequested(false);
            this.showMessage(msg, true);

            if (error) {
                console.error(error);
            }
        }
    }
};
</script>

<style lang="sass">
.Bim
    height: 100%
    display: flex
    flex-direction: column
    max-width: 100%
    background-color: var(--ms-light-grey)
    &-page
        height: calc( 100vh - var(--header-height) )
        position: relative
        padding-top: 8px
    &-mainContent
        position: relative
        flex-grow: 1
        display: flex
        overflow: hidden
    &-ProjectElementsTreeWrap
        margin:
            right: 0
            bottom: 8px
            left: 8px
        display: flex
        flex-direction: column
        flex-grow: 1
        .ProjectElementsTree
            flex-grow: 1
    &-BimViewWrap
        overflow: hidden
        width: calc(100% - 16px)
        position: relative
        height: calc(100% - 8px)
        display: flex
        flex-direction: column
        flex-grow: 1
        margin:
            top: 0
            right: 8px
            bottom: 8px
            left: 8px
        .BimView
            flex-grow: 1
</style>
