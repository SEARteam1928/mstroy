<template>
    <div class="GroupsControlTreeNode">
        <div class="GroupsControlTreeNode-label">{{ label }}</div>
        <div class="GroupsControlTreeNode-actions" @click.prevent.stop>
            <MiniBtnAdd
                class="MiniBtnAdd"
                :size="10"
                tooltip="Добавить дочернюю группу"
                @click="$emit('add', prop.node)"
            />
        </div>
    </div>
</template>

<script>
import MiniBtnAdd from '@components/common/MiniBtn/MiniBtnAdd.vue';

export default {
    name: 'GroupsControlTreeNode',
    components: {
        MiniBtnAdd
    },
    props: {
        prop: {
            type: Object,
            required: true
        },
        labelKey: {
            type: String,
            required: false,
            default: 'label'
        }
    },
    computed: {
        label() {
            return this.prop.node[this.labelKey];
        }
    }
};
</script>

<style lang="sass">
.GroupsControlTreeNode
    min-width: 100px
    color: var(--ms-dark)
    display: flex
    align-items: center
    position: relative
    &-actions
        position: absolute
        right: -36px
        top: 0
        bottom: 0
        display: flex
        align-items: center
</style>
