<template>
    <div class="GroupsControlActionsBlock">
        <GroupsControlActionsBlockHeader />

        <q-scroll-area
            class="GroupsControlActionsBlock-scrollArea"
            :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms', 'background-color': 'var(--ms-dark)' }"
        >
            <GroupsControlActionsBlockUsers />
        </q-scroll-area>

        <GroupsControlActionsBlockActions />
    </div>
</template>

<script>
import GroupsControlActionsBlockHeader from './GroupsControlActionsBlock/GroupsControlActionsBlockHeader.vue';
import GroupsControlActionsBlockUsers from './GroupsControlActionsBlock/GroupsControlActionsBlockUsers.vue';
import GroupsControlActionsBlockActions from './GroupsControlActionsBlock/GroupsControlActionsBlockActions.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'GroupsControlActionsBlock',
    components: {
        GroupsControlActionsBlockHeader,
        GroupsControlActionsBlockUsers,
        GroupsControlActionsBlockActions
    },
    computed: {
        ...mapGetters('GroupsControl', ['selectedGroupId', 'allAccessGroupsTreeMap'])
    }
};
</script>

<style lang="sass">
.GroupsControlActionsBlock
    position: relative
    height: 100%
    align-self: stretch
    color: var(--ms-dark)
    display: flex
    flex-direction: column
    &-scrollArea
        flex-grow: 1
        height: 100%
</style>
