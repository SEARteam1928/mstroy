<template>
    <q-item
        class="DrawerMenuItem no-user-select drawer-menu-item"
        :style="{ '--level': level - 1 }"
        :to="to"
        :draggable="false"
        clickable
        v-ripple:[ripple]
        :exact="exact"
        @click="$emit('click')"
    >
        <q-item-section v-if="icon" avatar class="drawer-menu-avatar">
            <slot name="icon">
                <QIconCustom :name="icon" :size="20" :colors="{ primary: '#fff' }" />
            </slot>
        </q-item-section>
        <q-item-section>
            <q-item-label class="drawer-menu-label" :class="{ 'drawer-menu-label-bold': bold }">
                {{ label }}
            </q-item-label>
        </q-item-section>

        <q-tooltip
            v-if="tooltip"
            transition-show="fade"
            transition-hide="fade"
            anchor="center right"
            self="center left"
            :offset="[8, 0]"
            content-class="bg-ms-dark"
        >
            {{ tooltipContent }}
        </q-tooltip>
    </q-item>
</template>

<script>
import QIconCustom from '../common/QIconCustom.vue';
import { colors } from 'quasar';

export default {
    name: 'DrawerMenuItem',
    props: {
        to: {
            type: [Object, String],
            required: false
        },
        ripple: {
            type: String,
            required: false
        },
        exact: {
            required: false
        },
        icon: {
            type: [Boolean, String],
            required: false
        },
        label: {
            type: String,
            required: false
        },
        bold: {
            type: Boolean,
            required: false,
            default: false
        },
        level: {
            type: Number,
            required: false,
            default: 1
        },
        tooltip: {
            type: [Boolean, String],
            required: false,
            default: false
        }
    },
    components: {
        QIconCustom
    },
    computed: {
        isActive() {
            let active = false;
            if (this.to) {
                let matched = this.$router.matcher.match(this.to).matched;
                matched.forEach(match => {
                    if (this.$route.path === match.path) active = true;
                });
            }

            return active;
        },
        iconColor() {
            return this.isActive ? colors.getBrand('menu-item-green') : colors.getBrand('custom-icon-primary');
        },

        tooltipContent() {
            let content = this.label;
            if (typeof this.tooltip === 'string') content = this.tooltip;

            return content;
        }
    }
};
</script>

<style lang="sass">
.DrawerMenuItem
    padding: 4px 12px
    padding-left: calc(var(--level) * 30px + 12px)
    position: relative
    min-height: 40px
    color: #fff
    overflow: hidden
    &.drawer-menu-item-left-rounded
        border-radius: 4px 0 0 4px
    &:before
        content: ''
        position: absolute
        top: 0
        bottom: 0
        left: 0
        border-left: 3px solid transparent
        border-radius: inherit
        z-index: 0
    &.q-router-link--exact-active
        color: #fff
        background: rgba(0, 0, 0, 0.15)
        border-color: #fff
        &:before
            border-color: #fff
    .drawer-menu-avatar
        width: 32px
        min-width: 32px
        height: 32px
        padding-right: 0
        align-items: center
    .q-item__section--main
        padding-left: 6px

    .drawer-menu-label-bold
        font-weight: 600

// body.desktop .DrawerMenuItem.q-hoverable:hover > .q-focus-helper
//     background: rgba(0, 0, 0, 0.02)
//     opacity: 1
//     z-index: -1
</style>
