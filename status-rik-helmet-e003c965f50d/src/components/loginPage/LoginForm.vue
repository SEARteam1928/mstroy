<template>
    <div class="LoginForm shadow-15">
        <h5 class="LoginForm-title">Авторизация</h5>

        <q-form class="LoginForm-form" @submit.prevent.stop="validationSuccessHandler">
            <div class="fields-container">
                <q-input
                    class="LoginForm-input"
                    filled
                    dense
                    no-error-icon
                    v-model="email"
                    :error-message="requiredTextEmail"
                    :rules="[emailValidator]"
                    color="ms-primary"
                    placeholder="Email"
                    ref="field_email"
                >
                    <template v-slot:append>
                        <QIconCustom name="user" :size="16" :colors="{ primary: '#6C83A1' }" />
                    </template>
                </q-input>

                <q-input
                    class="LoginForm-input"
                    filled
                    dense
                    no-error-icon
                    v-model="password"
                    color="ms-primary"
                    :error-message="requiredTextPass"
                    :rules="[passwordValidator]"
                    type="password"
                    placeholder="Пароль"
                    ref="field_pass"
                >
                    <template v-slot:append>
                        <QIconCustom name="lock-open-alt" :size="16" :colors="{ primary: '#6C83A1' }" />
                    </template>
                </q-input>
            </div>

            <div class="button-container">
                <q-btn
                    class="LoginForm-btnSubmit"
                    unelevated
                    color="ms-primary"
                    type="submit"
                    label="Войти"
                    :loading="waitingAuthResponse"
                    :disable="waitingAuthResponse"
                >
                    <template v-slot:loading>
                        <q-spinner-puff />
                    </template>
                </q-btn>
            </div>
        </q-form>
    </div>
</template>

<script>
import QIconCustom from '../common/QIconCustom.vue';

import withShowMessage from '@mixins/withShowMessage';

import Api from '@services/api';
import User from '@services/user';

import { colors as quasarColors } from 'quasar';

export default {
    name: 'LoginForm',
    components: {
        QIconCustom
    },
    mixins: [withShowMessage()],
    data() {
        return {
            email: '',
            password: '',
            requiredTextEmail: 'Это поле должно быть заполнено',
            requiredTextPass: 'Это поле должно быть заполнено',
            formValid: null,
            waitingAuthResponse: false,
            authTextSuccess: 'Вы успешно авторизовались',
            authTextFail: 'Не правильные логин или пароль',
            userFail: 'Ошибка получения пользователя',

            getBrand: quasarColors.getBrand
        };
    },
    methods: {
        emailValidator(val) {
            let valid = val.length > 0 ? true : false;
            return valid;
        },
        passwordValidator(val) {
            let valid = val.length > 0 ? true : false;
            return valid;
        },
        validationSuccessHandler() {
            this.checkAuth();
        },

        async checkAuth() {
            // Вешает прелоадер на кнопку "Отправить"
            this.waitingAuthResponse = true;
            let { email, password } = this;

            try {
                let res = await Api.login({ email, password });

                if (res.status === 'success') {
                    this.authSuccess(res);
                } else {
                    this.authFail(res);
                }
            } catch (error) {
                let { data } = error.response;
                this.authFail(data);
            }
        },

        authSuccess(res) {
            this.enterHandler(res);
        },
        authFail(res) {
            this.showMessage(res.message, true);

            this.waitingAuthResponse = false;
        },

        async enterHandler(res) {
            try {
                // После успешного получения информации о пользователе произойдет переход на главную
                await User.setUser(res.user.id, res.Authorization, true);

                this.showMessage(res.message);
            } catch (error) {
                let message = this.userFail;

                if (process.env.DEV) {
                    message = 'GraphQL: ' + message;

                    console.error(error);
                }
                this.showMessage(message, true);
            } finally {
                // После запроса снимает прелоадер с кнопки "Отправить"
                this.waitingAuthResponse = false;
            }
        }
    }
};
</script>

<style lang="sass">
.LoginForm
    padding: 40px 25px
    color: var(--ms-dark)
    text-align: center
    position: relative
    border-radius: 5px
    display: flex
    flex-direction: column
    &-title
        margin: 5px 0 40px 0
        user-select: none
    &-form
        display: flex
        flex-direction: column
        flex-grow: 1
        .fields-container
            flex-grow: 1
            display: flex
            flex-direction: column
            justify-content: center
    &-input
        margin-bottom: 15px
        color: var(--ms-dark)
        min-width: 300px
        input
            color: var(--ms-dark) !important
        &.q-field--error .q-field__bottom
            color: var(--ms-red)
        @media only screen and (max-width : 420px)
            min-width: 100%

        // Состояние инпута под ховером
        &.q-field--filled .q-field__control:before
            background: var(--ms-grey)
        &.q-field--filled .q-field__control:hover:before
            opacity: 0.1

        // Состояние инпута в фокусе
        &.q-field--filled .q-field__control
            background-color: var(--ms-light-grey)
        &.q-field--filled.q-field--focused .q-field__control:before
            opacity: 0.25
            background: var(--ms-grey)

    .text-negative
        color: var(--ms-red) !important

    &-btnSubmit
        width: auto
        margin-top: 16px
        .q-btn__wrapper
            padding: 4px 45px
</style>
