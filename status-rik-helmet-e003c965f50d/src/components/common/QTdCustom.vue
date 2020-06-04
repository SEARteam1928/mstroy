<template>
    <td v-if="col" :class="className" @click="$emit('click', props)">
        <slot></slot>
    </td>
</template>

<script>
export default {
    name: 'QTdCustom',
    props: {
        props: Object,
        autoWidth: Boolean
    },
    computed: {
        name() {
            return this.$vnode.key;
        },
        col() {
            let col;
            if (this.name) {
                col = this.props.colsMap[this.name];
                if (col === void 0) { return };
            } else {
                col = this.props.col;
            }

            return col;
        },
        className() {
            let stdClass = this.col ? this.col.__tdClass : '';
            return stdClass + (this.autoWidth === true ? ' q-table--col-auto-width' : '');
        }
    }
}
</script>