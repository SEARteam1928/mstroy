<template>
    <div class="UserPanel">
        <q-card-section>
            <q-input v-model="loginModel" outlined dense clearable type="text" label="Логин" />
        </q-card-section>

        <q-card-section>
            <q-input v-model="emailModel" outlined dense clearable type="text" label="E-mail" />
        </q-card-section>

        <q-card-section>
            <q-input v-model="passModel" outlined dense clearable type="text" label="Пароль" />
        </q-card-section>

        <q-checkbox class="UserPanel-checkbox" v-model="activeModel" label="Активный аккаунт" />
    </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'UserPanel',
    computed: {
        ...mapGetters('UsersControl', ['editUserModalData']),

        loginModel: {
            get() {
                return this.editUserModalData.username;
            },
            set(username) {
                this.setEditUserModalData({ username });
            }
        },
        emailModel: {
            get() {
                return this.editUserModalData.email;
            },
            set(email) {
                this.setEditUserModalData({ email });
            }
        },
        passModel: {
            get() {
                return this.editUserModalData.password;
            },
            set(password) {
                this.setEditUserModalData({ password });
            }
        },

        activeModel: {
            get() {
                return this.editUserModalData.active;
            },
            set(active) {
                this.setEditUserModalData({ active });
            }
        }
    },
    methods: {
        ...mapMutations('UsersControl', ['setEditUserModalData'])
    }
};
</script>

<style lang="sass">
.UserPanel
    &-checkbox
        padding-left: 16px
</style>
