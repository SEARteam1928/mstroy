<template>
    <transition name="fade">
        <div
            v-if="loading && !(error || warning || info)"
            class="DataPreloader DataPreloader-preloader"
            :class="{ 'vertical': vertical }"
            key="loading"
        >
            <q-spinner-puff
                class="DataPreloader DataPreloader-spinner"
                :style="{ '--size': size }"
                color="ms-dark"
                draggable="false"
            />
            <div class="DataPreloader-message text-ms-dark">{{ loadingMessage }}</div>
        </div>

        <div v-if="error" class="DataPreloader DataPreloader-error" :class="{ 'vertical': vertical }" key="error">
            <q-icon
                name="error"
                class="DataPreloader-icon"
                :style="{ '--size': size }"
                color="ms-dark"
                draggable="false"
            />
            <div class="DataPreloader-message text-ms-dark">{{ errorMessage }}</div>
        </div>

        <div v-if="warning" class="DataPreloader DataPreloader-warning" :class="{ 'vertical': vertical }" key="warning">
            <q-icon
                name="warning"
                class="DataPreloader-icon"
                :style="{ '--size': size }"
                color="ms-dark"
                draggable="false"
            />
            <div class="DataPreloader-message text-ms-dark">{{ warningMessage }}</div>
        </div>

        <div v-if="info" class="DataPreloader DataPreloader-info" :class="{ 'vertical': vertical }" key="info">
            <q-icon
                name="info"
                class="DataPreloader-icon"
                :style="{ '--size': size }"
                color="ms-dark"
                draggable="false"
            />
            <div class="DataPreloader-message text-ms-dark">{{ infoMessage }}</div>
        </div>

        <slot v-if="!loading && !error && !warning && !info" />
    </transition>
</template>

<script>
export default {
    name: 'DataPreloader',
    props: {
        loading: {
            type: Boolean,
            required: true
        },
        loadingMessage: {
            type: String,
            required: false,
            default: 'Загрузка данных'
        },
        error: {
            type: Boolean,
            required: false,
            default: false
        },
        errorMessage: {
            type: String,
            required: false,
            default: 'Ошибка загрузки данных'
        },
        warning: {
            type: Boolean,
            required: false,
            default: false
        },
        warningMessage: {
            type: String,
            required: false,
            default: 'Что-то пошло не так'
        },
        info: {
            type: Boolean,
            required: false,
            default: false
        },
        infoMessage: {
            type: String,
            required: false,
            default: 'Что-то пошло не так'
        },
        duration: {
            type: Number,
            required: false,
            default: 500
        },
        size: {
            type: Number,
            required: false,
            default: 50
        },
        vertical: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    watch: {
        duration(newDuration) {
            this.$nextTick(() => this.setDuration(newDuration));
        }
    },
    mounted() {
        // this.setDuration();
        this.$nextTick(() => this.setDuration());
    },
    methods: {
        setDuration(newDuration = this.duration) {
            // Вешает css переменную на родительский блок для прелоадера для того,
            // чтобы контент в слоте появлялся с указанной длительностью
            this.$el && this.$el.parentElement.style.setProperty('--data-preloader-duration', newDuration);
        }
    }
};
</script>

<style lang="sass" scoped>
.DataPreloader
    width: 100%
    justify-content: center
    &-preloader, &-error, &-warning, &-info
        display: flex
        align-items: center
        position: absolute
        left: 50%
        top: 50%
        transform: translate(-50%, -50%)
        z-index: 1
        user-select: none
        &.vertical
            flex-direction: column
    &-spinner, &-icon
        font-size: calc(var(--size) * 1px)
    &-message
        padding: 0 5px
        text-align: center

.fade-enter-active, .fade-leave-active
    transition: opacity calc(var(--data-preloader-duration) * 1ms)
.fade-enter, .fade-leave-to
    opacity: 0
</style>
