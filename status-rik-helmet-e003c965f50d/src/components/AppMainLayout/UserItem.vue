<template>
    <q-item class="UserItem" :draggable="false">
        <q-item-section avatar class="UserItem-avatar">
            <QIconCustom name="user-circle" :size="32" :colors="{ primary: '#fff' }" />
        </q-item-section>
        <q-item-section>
            <q-item-label class="UserItem-label">
                <div class="UserItem-labelName">{{ username }}</div>
                <span class="UserItem-labelExit" @click="logoutHandler">Выход</span>
            </q-item-label>
        </q-item-section>
    </q-item>
</template>

<script>
import QIconCustom from '../common/QIconCustom.vue';

import User from '@services/user';

import { mapGetters } from 'vuex';

export default {
    name: 'UserItem',
    components: {
        QIconCustom
    },
    computed: {
        ...mapGetters('User', ['username'])
    },
    methods: {
        logoutHandler() {
            User.resetUser();
        }
    }
};
</script>

<style lang="sass">
.UserItem
    display: flex
    align-items: center
    color: #fff
    &-avatar
        min-width: 32px
        width: 32px
        padding-right: 0
        opacity: 0.5
    &-label
        padding-left: 12px
    &-labelName
        font-size: 12px
        line-height: 14px
    &-labelExit
        line-height: 14px
        font-size: 10px
        margin-top: -3px
        cursor: pointer
        opacity: 0.5
        transition: opacity 250ms ease
        &:hover
            opacity: 0.9
</style>
