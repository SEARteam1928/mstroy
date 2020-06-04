<template>
    <q-btn
        class="MiniBtn MiniBtnAdd"
        dense
        round
        flat
        color="ms-dark"
        :size="size + 'px'"
        :title="title"
        @click.prevent.stop="$emit('click')"
    >
        <q-icon name="add_circle" color="ms-grey" :size="size * 2 - size / 2 + 1 + 'px'" />
        <q-tooltip
            v-if="tooltip"
            anchor="top middle"
            self="center middle"
            :delay="700"
            :content-style="{ 'background-color': 'var(--ms-dark)' }"
            >{{ tooltip }}</q-tooltip
        >
    </q-btn>
</template>

<script>
export default {
    name: 'MiniBtnAdd',
    props: {
        size: {
            type: Number,
            required: false,
            default: 8
        },
        tooltip: {
            type: String,
            required: false
        },
        title: {
            type: String,
            required: false
        }
    }
};
</script>

<style lang="sass">
.MiniBtnAdd
    transition: color 250ms ease-in-out
    .q-icon
        transition: color 250ms ease-in-out
    &:hover
        color: var(--ms-blue) !important
        .q-icon
            color: var(--ms-blue) !important
</style>
