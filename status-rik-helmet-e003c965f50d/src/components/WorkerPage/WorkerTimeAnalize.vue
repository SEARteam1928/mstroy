<template>
    <q-card flat bordered class="time-analizer-card">
        <q-card-section class="time-analizer-header time-analizer-section">
            <div class="text-h6">Трудозатраты</div>
        </q-card-section>

        <q-separator inset />

        <q-card-section class="time-analizer-section">
            <div class="row items-center time-analizer-info">
                <q-circular-progress
                    disable
                    v-model="percent"
                    show-value
                    size="80px"
                    :thickness="0.2"
                    color="menu-item-green"
                    track-color="grey-3"
                    class="text-primary time-analizer-progress"
                >
                    <div class="progress-text text-menu-item-green">{{percent}}%</div>
                </q-circular-progress>

                <div class="time-analizer-descr">
                    <div class="amount-minutes text-h5">{{accepted}}/{{total}}</div>
                    <div class="descr-minutes text-grey">Минут принято</div>
                </div>
            </div>
        </q-card-section>
    </q-card>
</template>

<script>
export default {
    name: 'WorkerTimeAnalize',
    props: {
        accepted: Number,
        total: Number
    },
    computed: {
        percent() {
            if(this.total === 0) return 0;
            return Math.round((this.accepted * 100) / this.total);
        },
    }
}
</script>

<style lang="sass" scoped>
.time-analizer
    &-card
    &-section
        padding: 8px 16px
    &-header
    &-info
        @media only screen and (max-width : 599px)
            justify-content: center
    &-progress
        margin-right: 16px
    &-descr
        @media only screen and (max-width : 599px)
            justify-content: center
</style>