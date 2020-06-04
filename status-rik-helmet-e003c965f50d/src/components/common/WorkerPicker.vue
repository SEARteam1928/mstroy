<template>
    <div class="WorkerPicker">
        <q-expansion-item
            class="WorkerPicker-expansion"
            :class="{ 'shadow-3': openExpandModel }"
            :duration="duration"
            :style="{ '--duration': duration }"
            header-class="WorkerPicker-titleSection"
            expand-icon-class="WorkerPicker-openBtn"
            expanded-icon="clear"
            expand-icon-toggle
            v-model="openExpandModel"
            @before-show="$emit('before-show')"
            @show="$emit('show')"
            @after-show="$emit('after-show')"
            @before-hide="$emit('before-hide')"
            @hide="$emit('hide')"
            @after-hide="$emit('after-hide')"
        >
            <template v-slot:header>
                <div class="WorkerPicker-header">
                    <transition name="WorkerPicker-fade">
                        <div v-if="!openExpandModel" class="WorkerPicker-title">
                            {{ displayValue }}
                        </div>

                        <input
                            v-if="openExpandModel"
                            class="WorkerPicker-search"
                            v-model="searchModel"
                            type="text"
                            placeholder="Поиск сотрудника"
                            ref="search"
                        />
                    </transition>
                </div>
            </template>

            <div class="WorkerPicker-list">
                <q-scroll-area
                    class="WorkerPicker-listScroll"
                    :thumb-style="{
                        'transition': 'top 100ms ease, opacity 300ms',
                        'background-color': 'var(--ms-dark)'
                    }"
                >
                    <div
                        class="WorkerPicker-listItem"
                        v-for="worker in filteredWorkers"
                        :key="worker[nodeKey]"
                        @click="onListItemClick(worker)"
                    >
                        {{ worker[labelKey] }}
                    </div>
                </q-scroll-area>
            </div>
        </q-expansion-item>
    </div>
</template>

<script>
export default {
    name: 'WorkerPicker',
    props: {
        workers: {
            type: Array,
            required: true
        },
        value: {
            validator: prop => typeof prop === 'object' || prop === null || prop === undefined
        },
        nodeKey: {
            type: String,
            required: false,
            default: 'id'
        },
        labelKey: {
            type: String,
            required: false,
            default: 'name'
        },
        duration: {
            type: Number,
            required: false,
            default: 250
        },
        open: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    data() {
        return {
            openExpandModel: false,
            searchModel: ''
        };
    },
    computed: {
        displayValue() {
            return this.value ? this.value[this.labelKey] : '';
        },

        filteredWorkers() {
            return this.workers.filter(worker =>
                worker[this.labelKey].toLowerCase().includes(this.searchModel.toLowerCase())
            );
        }
    },
    watch: {
        open: {
            handler(newOpen) {
                this.openExpandModel = newOpen;
            },
            immediate: true
        },
        openExpandModel(val) {
            // При закрытии выпадашки очищаем фильтр
            if (!val) {
                this.searchModel = '';
                this.$emit('close');
                return;
            }

            // При открытии выпадашки ставим фокус на поле поиска
            this.$nextTick(() => this.$refs.search.focus());
            this.$emit('open');
        }
    },
    methods: {
        onListItemClick(worker) {
            this.$emit('input', worker);
            this.openExpandModel = false;
        }
    }
};
</script>

<style lang="sass">
.WorkerPicker
    width: 100%
    height: 48px
    background-color: #fff
    &-expansion
        border-width: 1px
        border-style: solid
        border-color: transparent
        border-radius: 4px
        will-change: box-shadow
        transition: border-color calc(var(--duration) * 1ms) ease-in-out, box-shadow calc( var(--duration) * 1ms ) ease-in-out
        z-index: 10
    &-titleSection
        padding: 0
        &:after
            content: ''
            position: absolute
            bottom: 0
            left: 50%
            opacity: 0.4
            width: calc(100% - 16px)
            border-bottom-width: 1px
            border-bottom-style: solid
            border-bottom-color: transparent
            transform: translateX(-50%)
    &-header
        position: relative
        width: 100%
        height: 100%
        min-height: 48px
        display: flex
        align-items: center
    &-title
        position: absolute
        top: 0
        bottom: 0
        width: 100%
        flex-grow: 1
        margin: 8px 16px
        display: flex
        align-items: center
        color: var(--ms-dark)
    &-search
        position: absolute
        top: 0
        bottom: 0
        left: 0
        right: 0
        width: calc(100% - 16px)
        flex-grow: 1
        margin: 8px
        border: none
        padding: 4px 8px
        border-radius: 4px
        background-color: var(--ms-light-grey)
        color: var(--ms-dark)
        &:focus
            outline: none
        &::placeholder
            font-size: 12px
            color: var(--ms-grey)
    &-openBtn
        width: 54px
        padding: 0 8px
        font-size: 32px
        .q-icon
            font-size: 32px
            color: var(--ms-grey)
        &:before
            content: ''
            position: absolute
            top: 0
            bottom: 0
            left: 0
            width: 1px
            background-color: var(--ms-grey)

    &-list
        width: 100%
        height: 50vh
        padding-top: 8px;
        background-color: #fff
    &-listScroll
        height: 100%
        flex-grow: 1
        align-self: stretch
    &-listItem
        color: var(--ms-dark)
        margin: 14px
        padding: 16px
        border-radius: 4px
        transition: background-color 150ms ease-in-out
        cursor: pointer
        &:hover
            background-color: var(--ms-light-grey)

    &-fade-enter-active, &-fade-leave-active
        transition: opacity 250ms ease-in-out
    &-fade-enter, &-fade-leave-to
        opacity: 0

// Закрытое состояние
.WorkerPicker-expansion
    &.q-expansion-item--collapsed
        border-color: var(--ms-grey)

// Открытое состояние
.WorkerPicker-expansion
    &.q-expansion-item--expanded
        .WorkerPicker
            &-titleSection
                &:after
                    border-bottom-color: var(--ms-grey)
            &-openBtn
                &:before
                    background-color: transparent
</style>
