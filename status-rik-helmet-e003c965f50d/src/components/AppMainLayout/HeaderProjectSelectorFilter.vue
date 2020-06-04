<template>
    <div class="HeaderProjectSelectorFilter">
        <q-input dense clearable v-model="filterModel" label="Поиск проекта" color="ms-primary" ref="inputFilter" />
    </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'HeaderProjectSelectorFilter',
    computed: {
        ...mapGetters('Projects', ['projectsFilter']),

        filterModel: {
            get() {
                return this.projectsFilter;
            },
            set(val) {
                val = val ? val : '';

                this.setProjectsFilter(val);
            }
        }
    },
    mounted() {
        if (this.$refs.inputFilter) {
            this.$nextTick(() => {
                this.$refs.inputFilter.focus();
            });
        }
    },
    beforeDestroy() {
        this.filterModel = null;
    },
    methods: {
        ...mapMutations('Projects', ['setProjectsFilter'])
    }
};
</script>
