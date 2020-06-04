<template>
    <div class="GroupsControlHeader">
        <q-btn
            class="GroupsControlHeader-addGroupBtn"
            unelevated
            label="+ Добавить группу"
            color="ms-primary"
            @click="onAddGroupBtnClick"
        />
    </div>
</template>

<script>
import { mapMutations } from 'vuex';

export default {
    name: 'GroupsControlHeader',
    methods: {
        ...mapMutations('GroupsControl', ['setIsOpenEditGroupModal']),

        onAddGroupBtnClick() {
            this.setIsOpenEditGroupModal(true);
        }
    }
};
</script>

<style lang="sass">
.GroupsControlHeader
    width: 100%
    padding: 8px 16px
    display: flex
</style>
