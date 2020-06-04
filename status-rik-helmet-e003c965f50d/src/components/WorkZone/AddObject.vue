<template>
    <div class="add-object">
        <q-input
            class="add-object-field add-object-name"
            ref="name"
            filled
            dense
            hide-bottom-space
            v-model="name"
            label="Название"
            :rules="[val => val.trim().length >= 1]"
        />

        <q-input
            class="add-object-field add-object-color"
            ref="color"
            filled
            dense
            hide-bottom-space
            v-model="color"
            :rules="['anyColor']"
            label="Цвет"
        >
            <template v-slot:append>
                <q-icon name="colorize" class="cursor-pointer">
                    <q-popup-proxy transition-show="scale" transition-hide="scale">
                        <q-color dense v-model="color" />
                    </q-popup-proxy>
                </q-icon>
            </template>
        </q-input>

        <q-input
            class="add-object-field add-object-coordinates"
            ref="coordinates"
            filled
            dense
            autogrow
            hide-bottom-space
            input-class="add-object-textfield"
            v-model="coordinates"
            label="Координаты"
            :rules="[val => val.trim().length >= 1]"
        />

        <q-checkbox
            class="add-object-field add-object-workzone"
            dense
            v-model="is_work_area"
            label="Рабочая зона"
            color="primary"
        />

        <div class="add-object-buttons">
            <q-btn
                class="add-object-submit"
                outline
                color="primary"
                label="Создать"
                @click="submit"
                :loading="isLoading"
                :disable="isLoading"
            >
                <template v-slot:loading>
                    <q-spinner-puff />
                </template>
            </q-btn>

            <q-btn
                class="add-object-clear"
                outline
                color="negative"
                label="Сброс"
                @click="clear"
                :disable="isLoading"
            />
        </div>
    </div>
</template>

<script>
export default {
    name: 'AddObject',
    data() {
        return {
            name: '',
            color: '#3388ff',
            coordinates: '',
            is_work_area: true,
            // FIXME: пока другие project_id не доступны, будет захардкожен 1
            project_id: 1,
            isLoading: false,
            errorState: false,
            successState: false
            // statusText: ''
        };
    },
    methods: {
        // Метод установки состояния ошибки, вызывается родителем
        error() {
            this.isLoading = false;
            this.successState = false;
            this.errorState = true;
        },
        // Метод установки состояния успешного добавления, вызывается родителем
        success() {
            this.isLoading = false;
            this.successState = true;
            this.errorState = false;

            this.clear();
        },
        // Обработчик кнопки "Создать"
        submit() {
            let nameValid = this.$refs.name.validate();
            let colorValid = this.$refs.color.validate();
            let coordinatesValid = this.$refs.coordinates.validate();
            // Если не пройдена валидация хотя бы одним полем - выходим
            if (!nameValid || !colorValid || !coordinatesValid) return;

            let coordinates = this.buildCoordinates();
            // Если не распарсились координаты - выходим
            if (!coordinates.length) return;

            // Собираем объект данных на отправку
            let { name, color, is_work_area, project_id } = this;
            name = name.trim();
            color = color.trim();

            let objectData = {
                name,
                color,
                coordinates,
                is_work_area,
                project_id
            };

            this.isLoading = true;

            // и шлем его в событии родителю
            this.$emit('add', objectData);
        },
        // Обработчик кнопки "Сброс"
        clear() {
            // Сброс данных
            this.name = '';
            this.color = '#3388ff';
            this.coordinates = '';
            this.is_work_area = true;

            // и состояния валидации
            this.$nextTick(() => {
                this.$refs.name.resetValidation();
                this.$refs.color.resetValidation();
                this.$refs.coordinates.resetValidation();
            });

            this.errorState = false;

            // Если сброс после успешной отправки, сообщение об успехе уберем через 2сек
            if (this.successState) {
                setTimeout(() => {
                    this.successState = false;
                }, 2000);
            } else {
                this.successState = false;
            }
        },
        // Парсер массива координат из textarea
        buildCoordinates() {
            let coordinates = this.coordinates
                .split(/\n/)
                .filter(row => row.trim())
                .map(row => row.split(/\s*?,\s*?/))
                .map(coord => {
                    let lat = Number(coord[0]);
                    let lng = Number(coord[1]);

                    if (isNaN(lat) || isNaN(lng)) return;

                    return [lat, lng];
                })
                .filter(coord => coord);

            return coordinates;
        }
    }
};
</script>

<style lang="sass">
.add-object
    margin: 10px
    &-field
        min-width: 250px
        margin-bottom: 10px
    &-coordinates
        &.q-textarea.q-field--dense .q-anchor--skip
            padding-top: 20px
    &-textfield
        max-height: 280px
    &-buttons
        display: flex
        justify-content: space-between
        margin: 6px 10px 12px
    &-submit
    &-clear
</style>
