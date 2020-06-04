<template>
    <q-card-section class="WorkSessionsEditModal-workerSection">
        <q-select
            class="WorkSessionsEditModal-workerSelect"
            outlined
            use-input
            dense
            clearable
            v-model="workerModel"
            :options="workerOptions"
            :loading="loadingWorkers"
            input-debounce="0"
            label="Выбор работника"
            option-label="name"
            option-value="id"
            @input="onChangeWorker"
            @filter="filterFn"
        >
            <template v-slot:no-option>
                <q-item>
                    <q-item-section class="text-grey">Не найдено</q-item-section>
                </q-item>
            </template>
        </q-select>
    </q-card-section>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'WorkerSection',
    computed: {
        ...mapGetters('WorkSessions', ['editModalData', 'availableWorkers']),

        loadingWorkers() {
            return this.availableWorkers.length === 0;
        }
    },
    data() {
        return {
            workerModel: null,
            workerOptions: []
        };
    },
    created() {
        this.workerOptions = this.availableWorkers;

        // В режиме редактирования в хранилище будет лежать time_resource_id.
        // Если он там есть, найдем соответствующего работника и подставим его в селект
        let availableWorker = this.findAvailableWorkerByTimeResourceId(this.editModalData.time_resource_id);
        if (availableWorker) {
            this.workerModel = availableWorker;
        }
    },
    methods: {
        ...mapMutations('WorkSessions', ['setEditModalData']),

        findAvailableWorkerByTimeResourceId(timeResourceId) {
            return this.availableWorkers.find(({ id }) => id === timeResourceId);
        },

        // Метод поиска и фильтрации списка работников по имени из инпута в селекте
        filterFn(val, update) {
            update(
                () => {
                    if (val === '') {
                        this.workerOptions = this.availableWorkers;
                    } else {
                        let needle = val.toLowerCase();

                        this.workerOptions = this.availableWorkers.filter(
                            ({ name }) => name.toLowerCase().indexOf(needle) > -1
                        );
                    }
                },

                // Этот аргумент нужен для того, чтобы после ввода каждого символа ставить фокус на первый пункт опщнов
                // Нужно для того, чтобы по нажатию Enter после ввода первый опшн автоматически становился выбранным
                // ref - инстанс q-select
                ref => {
                    if (val !== '' && ref.options.length > 0) {
                        // Сброс фокуса с опшнов
                        ref.setOptionIndex(-1);
                        // Установка фокуса на первый опшн
                        ref.moveOptionSelection(1, true);
                    }
                }
            );
        },
        onChangeWorker(prop) {
            let time_resource_id = null;

            if (prop instanceof Object) {
                time_resource_id = prop.id;
            }

            this.setEditModalData({ time_resource_id });
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsEditModal
    &-workerSection
    &-workerSelect
</style>
