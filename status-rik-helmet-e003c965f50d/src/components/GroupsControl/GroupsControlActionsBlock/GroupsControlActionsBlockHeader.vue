<template>
    <div class="GroupsControlActionsBlockHeader">
        Информация по группе
        <div class="GroupsControlActionsBlockHeader-name">{{ selectedGroupName }}</div>
    </div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
    name: 'GroupsControlActionsBlockHeader',
    computed: {
        ...mapGetters('GroupsControl', ['selectedGroupId', 'selectedGroup']),

        selectedGroupName() {
            return this.selectedGroup ? `"${this.selectedGroup.name}"` : '';
        }
    }
};
</script>

<style lang="sass">
.GroupsControlActionsBlockHeader
    padding: 12px
    border-bottom: 1px solid var(--ms-grey)
    text-align: center
    &-name
        font-weight: bold
</style>
