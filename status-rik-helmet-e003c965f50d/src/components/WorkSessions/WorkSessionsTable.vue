<template>
    <div class="WorkSessionsTable">
        <div class="WorkSessionsTable-head">
            <div class="WorkSessionsTable-head-content">
                Шапка таблицы
            </div>

            <div class="WorkSessionsTable-head-progress">
                <q-linear-progress class="q-linear-progress" v-if="!dataIsAvailable" indeterminate />
            </div>
        </div>
        <div v-if="dataIsAvailable" class="WorkSessionsTable-body">
            <q-scroll-area
                class="WorkSessionsTable-body-scroll-section"
                :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }"
            >
                <WorkSessionsTableRow
                    v-for="device in devices"
                    :key="device.id"
                    :deviceId="device.id"
                    :label="device.name"
                />
            </q-scroll-area>
        </div>
    </div>
</template>

<script>
import WorkSessionsTableRow from './WorkSessionsTableRow.vue';
import { mapGetters } from 'vuex';

export default {
    name: 'WorkSessionsTable',
    components: {
        WorkSessionsTableRow
    },
    computed: {
        ...mapGetters('WorkSessions', ['devices', 'dataIsAvailable'])
    }
};
</script>

<style lang="sass">
.WorkSessionsTable
    display: flex
    flex-direction: column
    max-height: 100%
    @media only screen and (max-width : 768px)
        border-left: none
        border-right: none
        border-bottom: none
    &-head
        font-size: 16px
        line-height: 18px
        font-weight: 600
        height: 50px
        position: relative
        border-bottom: 1px solid #000
        &-content
            text-align: center
            display: flex
            align-items: center
            justify-content: center
            height: 100%
        &-progress
            width: 100%
            position: absolute
            bottom: 0
            .q-linear-progress__track--light
                background-color: #fff
    &-body
        flex-grow: 1
        &-scroll-section
            height: 100%
</style>
