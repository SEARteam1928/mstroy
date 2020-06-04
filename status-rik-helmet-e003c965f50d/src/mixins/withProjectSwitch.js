import { mapGetters, mapMutations } from 'vuex';

export default (moduleName, immediate = true) => {
    return {
        computed: {
            ...mapGetters('Projects', {
                'Projects_selectedProjectId': 'selectedProjectId',
                'Projects_selectedProject': 'selectedProject',
                'Projects_allProjects': 'allProjects'
            })
        },
        watch: {
            Projects_selectedProjectId: {
                handler(newId, oldId) {
                    if (newId === oldId) return;

                    this.setProjectId(newId);
                    this.projectSwitch(newId);
                },
                immediate
            },
            Projects_selectedProject: {
                handler(newProject, oldProject) {
                    if (newProject && oldProject && newProject.rowId === oldProject.rowId) return;

                    this.projectSwitchProject(newProject);
                },
                deep: true
            }
        },
        methods: {
            ...mapMutations(moduleName, ['setProjectId']),

            projectSwitch(newId) {},
            projectSwitchProject(newProject) {}
        }
    };
};
