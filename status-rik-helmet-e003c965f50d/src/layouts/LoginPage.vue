<template>
    <div class="LoginPage">
        <div class="LoginPage-logo">
            <img
                class="LoginPage-logoImg"
                src="statics/logos/MStroy_horizontal.svg"
                alt="LogoMStroy"
                draggable="false"
            />
        </div>
        <LoginForm class="LoginForm" />
    </div>
</template>

<script>
import LoginForm from '../components/loginPage/LoginForm.vue';

export default {
    name: 'LoginPage',
    meta: {
        title: 'Вход',
        titleTemplate: title => `${title} - BIM-портал`
    },
    components: {
        LoginForm
    },
    data() {
        return {
            slides: ['statics/login-page/slides/1.jpg'],
            pageIsView: false,
            showLoginForm: false
        };
    },
    computed: {
        pageIsViewClass() {
            return this.pageIsView ? 'is-view' : '';
        }
    },
    methods: {
        loginHandler() {},
        enterBtnHandler() {
            this.showLoginForm = true;
        }
    },
    mounted() {
        // Запуск анимации появления элементов на странице
        setTimeout(() => {
            this.pageIsView = true;
        }, 50);
    }
};
</script>

<style lang="sass">
.LoginPage
    width: 100vw
    height: 100vh
    display: flex
    flex-direction: column
    justify-content: center
    align-items: center
    &-logo
        width: 450px
        max-width: 90%
        margin-bottom: 24px
    &-logoImg
        width: 100%
    .LoginForm
        max-width: 90%
        @media only screen and (max-width : 420px)
            width: 90%
</style>
