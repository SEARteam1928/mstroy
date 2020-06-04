<template>
    <div class="SessionItem">
        <div class="SessionItem-workerName" :title="workerFullName">{{ workerName }}</div>
        <div class="SessionItem-sessionPeriod">{{ sessionPeriod }}</div>
        <div class="SessionItem-sessionActions">
            <!-- Кнопка редактирования сессии -->
            <q-btn
                class="SessionItem-editSessionBtn"
                dense
                round
                flat
                color="ms-dark"
                size="8px"
                @click="onEditSessionBtnClick"
            >
                <q-icon name="edit" color="ms-grey" size="15px" />
            </q-btn>
            <!-- Кнопка удаления сессии -->
            <q-btn
                class="SessionItem-deleteSessionBtn"
                dense
                round
                flat
                color="ms-dark"
                size="8px"
                @click="onDeleteSessionBtnClick"
            >
                <q-icon name="delete" color="ms-grey" size="15px" />
            </q-btn>
        </div>
    </div>
</template>

<script>
import shortName from '@services/utils/shortName';
import dateParse from '@services/utils/dateUtils/parse';

import { date as quasarDate } from 'quasar';

export default {
    name: 'SessionItem',
    props: {
        session: {
            type: Object,
            required: true
        }
    },
    computed: {
        workerName() {
            let { lastName, firstName, surname } = this.session.workers[0];

            return shortName(lastName, firstName, surname);
        },

        workerFullName() {
            let { lastName, firstName, surname } = this.session.workers[0];

            return shortName(lastName, firstName, surname, true);
        },

        sessionPeriod() {
            let { startDate, finishDate } = this.session;

            startDate = dateParse(startDate);
            startDate = quasarDate.formatDate(startDate, this.dateMask);

            finishDate = dateParse(finishDate);
            finishDate = quasarDate.formatDate(finishDate, this.dateMask);

            return `${startDate}-${finishDate}`;
        }
    },
    data() {
        return {
            dateMask: 'DD.MM.YY'
        };
    },
    methods: {
        onEditSessionBtnClick() {
            this.$emit('edit', this.session);
        },
        onDeleteSessionBtnClick() {
            this.$emit('delete', this.session);
        }
    }
};
</script>

<style lang="sass">
.SessionItem
    display: flex
    padding: 4px 0
    border-radius: 4px
    cursor: default
    transition: background-color 250ms ease-in-out
    &-workerName
        width: calc(100% - 250px)
        height: 20px
        padding: 0 4px
        flex-grow: 1
        line-height: 20px
        word-break: break-all
        overflow: hidden
        display: -webkit-box
        -webkit-box-orient: vertical
        -webkit-line-clamp: 1
    &-period
    &-sessionActions
        margin-left: 8px
        opacity: 0
        transition: opacity 250ms ease-in-out
    &-editSessionBtn,
    &-deleteSessionBtn
        transition: color 250ms ease-in-out

    &-editSessionBtn
        margin-right: 4px
        &:hover
            color: var(--ms-primary) !important
            .q-icon
                color: var(--ms-primary) !important

    &-deleteSessionBtn
        &:hover
            color: var(--ms-red) !important
            .q-icon
                color: var(--ms-red) !important

    &:hover
        background-color: var(--ms-light-grey)
        .SessionItem
            &-sessionActions
                opacity: 1
</style>
