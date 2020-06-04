<template>
    <div class="DevicesSessionsDevicesTableHeader">
        <div class="DevicesSessionsDevicesTableHeader-col col-checkbox" :class="{ 'isShowCheckbox': isShowCheckbox }">
            <q-checkbox dense v-model="checkboxModel" color="ms-primary" />
        </div>
        <div class="DevicesSessionsDevicesTableHeader-col col-number">№</div>
        <div class="DevicesSessionsDevicesTableHeader-col col-worker">Сотрудник</div>
        <div class="DevicesSessionsDevicesTableHeader-col col-connect">Связь</div>
        <div class="DevicesSessionsDevicesTableHeader-col col-status">Статус</div>
        <div class="DevicesSessionsDevicesTableHeader-col col-active">Активность</div>
        <div class="DevicesSessionsDevicesTableHeader-col col-battery">Батарея</div>
    </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'DevicesSessionsDevicesTableHeader',
    computed: {
        ...mapGetters('DevicesSessions', ['isAllSelectedDevicesId']),

        checkboxModel: {
            get() {
                return this.isAllSelectedDevicesId;
            },
            set(val) {
                if (val === true) {
                    this.selectAllSelectedDevicesId();
                } else if (val === false) {
                    this.removeAllSelectedDevicesId();
                }
            }
        },
        isShowCheckbox() {
            return this.isAllSelectedDevicesId === true || this.isAllSelectedDevicesId === null;
        }
    },
    methods: {
        ...mapMutations('DevicesSessions', ['selectAllSelectedDevicesId', 'removeAllSelectedDevicesId'])
    }
};
</script>

<style lang="sass">
.DevicesSessionsDevicesTableHeader
    width: 100%
    display: flex
    padding: 0 8px
    height: 40px
    &-col
        width: 100%
        align-self: stretch
        display: flex
        align-items: center
        color: var(--ms-grey)
        transition: color 250ms ease-in-out
        padding: 4px
        // border: 1px solid #00f
        &:hover
            color: var(--ms-dark)
        &.col-number
            max-width: 48px
        &.col-checkbox
            max-width: 32px
            opacity: 0
            transition: opacity 100ms ease-in-out
            &:hover
                opacity: 1
            &.isShowCheckbox
                opacity: 1
</style>
