<template>
    <q-badge
        class="MonthTableTableBadge"
        :class="{ [`text-${colors[type]}`]: isEmpty, 'isEmpty': isEmpty }"
        :color="colors[type]"
        text-color="dark"
        :label="label"
    />
</template>

<script>
import { isFalse } from '@services/utils';

export default {
    name: 'MonthTableTableBadge',
    props: {
        value: {
            type: [String, Number],
            required: false
        },
        type: {
            type: String,
            required: false,
            default: 'excel'
        }
    },
    data() {
        return {
            colors: {
                excel: 'green-3',
                device: 'blue-3'
            }
        };
    },
    computed: {
        isEmpty() {
            return isFalse(this.value);
        },
        label() {
            return this.isEmpty ? 0 : this.value;
        }
    }
};
</script>

<style lang="sass">
.MonthTableTableBadge
    padding: 2px 4px
    &.isEmpty
        user-select: none
</style>
