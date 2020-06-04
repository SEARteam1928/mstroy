<template>
    <q-dialog
        :content-class="'Modal ' + contentClass"
        :maximized="maximized"
        :persistent="persistent"
        :value="value"
        @input="$emit('input')"
        @before-show="$emit('before-show')"
        @show="onShowDialog"
        @after-show="$emit('after-show')"
        @before-hide="$emit('before-hide')"
        @hide="$emit('hide')"
        @after-hide="$emit('after-hide')"
        ref="dialog"
    >
        <q-card
            class="Modal-card"
            :class="{ [cardClass]: cardClass, 'resizeDuration': resizeDuration }"
            :style="{ '--resizeDuration': resizeDuration }"
            ref="card"
        >
            <q-card-section class="Modal-header">
                <div class="Modal-title">
                    <slot name="title" />
                </div>
                <q-btn
                    class="Modal-close modal-close-btn-dense with-mobile"
                    color="ms-dark"
                    size="14px"
                    icon="close"
                    flat
                    dense
                    @click="onPersistentBtnClick"
                />
            </q-card-section>

            <q-scroll-area
                class="Modal-bodyScroll hide-scrollbar"
                :thumb-style="{
                    'transition': 'top 100ms ease, opacity 300ms',
                    'background-color': 'var(--ms-dark)'
                }"
            >
                <q-card-section class="Modal-body hide-scrollbar" ref="body">
                    <slot />
                    <slot name="body" />
                </q-card-section>
            </q-scroll-area>

            <q-card-actions v-if="actions" class="Modal-actions" :align="alignActions">
                <slot name="actions" />
            </q-card-actions>

            <q-resize-observer @resize="onModalResize" ref="resizeObserver" />
        </q-card>
    </q-dialog>
</template>

<script>
export default {
    name: 'Modal',
    props: {
        contentClass: {
            type: String,
            required: false,
            default: ''
        },
        cardClass: {
            type: String,
            required: false,
            default: ''
        },
        maximized: {
            type: Boolean,
            required: false,
            default: false
        },
        persistent: {
            type: Boolean,
            required: false,
            default: false
        },
        persistentBtn: {
            type: Boolean,
            required: false,
            default: false
        },
        value: {
            type: Boolean,
            required: true
        },
        actions: {
            type: Boolean,
            required: false,
            default: true
        },
        alignActions: {
            type: String,
            required: false,
            default: 'center'
        },
        resizeDuration: {
            type: Number,
            required: false,
            default: 0
        }
    },
    data() {
        return {
            isActiveResizeAnim: false,
            lastBodyHeight: null
        };
    },
    updated() {
        // При обновлении контента модалки будем перезапускать расчет высоты контента
        this.calcBodySize();
    },
    methods: {
        // Расчет высоты контента модалки для организации кастомного скролла
        calcBodySize() {
            if (this.resizeDuration && this.isActiveResizeAnim) return;
            let { card, body } = this.$refs;
            if (!card || !body) return;

            let bodyHeight = body.$el.scrollHeight;
            let cardElem = card.$el;
            cardElem.style.setProperty('--bodyHeight', bodyHeight + 1);

            if (this.resizeDuration) {
                this.isActiveResizeAnim = true;

                setTimeout(() => {
                    this.isActiveResizeAnim = false;

                    this.calcBodySize();
                }, this.resizeDuration);
            }
        },
        onModalResize(size) {
            // При изменении размеров модалки будем перезапускать расчет высоты контента
            this.calcBodySize();
        },

        onShowDialog() {
            this.calcBodySize();
            this.$emit('show');
        },

        onPersistentBtnClick() {
            // Если запрещено закрытие модалки кнопкой
            if (this.persistentBtn) {
                // Просто встряхиваем окно модалки
                this.$refs?.dialog?.shake();
            } else {
                // Если не запрещено закрытие, то прячем модалку
                this.$refs?.dialog?.hide();
            }
        }
    }
};
</script>

<style lang="sass">
.Modal
    &-card
        color: var(--ms-dark)
        box-shadow: var(--shadow10) !important
        display: flex
        flex-direction: column
        overflow: hidden
        will-change: height, scroll-position !important
    &-header
        padding-bottom: 16px
    &-title
        text-align: center
        font-size: 16px
        margin: 0 40px
    &-bodyScroll
        height: 100%
        flex-grow: 1
        align-self: stretch
        display: flex
        flex-direction: column
        overflow: auto
        will-change: height, scroll-position
        & > .scroll
            will-change: height, scroll-position
            height: calc(var(--bodyHeight) * 1px) !important
            min-height: 100%
    &-body
        height: 100%
        padding: 0 32px
        flex-grow: 1
        align-self: stretch
        display: flex
        flex-direction: column
        justify-content: center
        will-change: height, scroll-position
    &-actions
        padding-bottom: 16px

    .q-dialog__backdrop
        background: rgba(19, 43, 77, 0.3)
        backdrop-filter: blur(3px)

.Modal-card.resizeDuration
    .Modal-bodyScroll > .scroll
        transition: height calc(var(--resizeDuration) * 1ms) ease-in-out
</style>
