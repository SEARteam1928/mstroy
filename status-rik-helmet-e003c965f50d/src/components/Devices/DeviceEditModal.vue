<template>
    <q-card class="DeviceEditModal">
        <q-card-section class="DeviceEditModal-header">
            <div class="DeviceEditModal-title">{{ title }}</div>

            <q-btn
                class="DeviceEditModal-close modal-close-btn close-red with-mobile no-radius-top-left no-radius-top-right no-radius-bottom-right"
                :class="{ 'DeviceEditModal-closeMobile': $q.screen.xs }"
                icon="close"
                flat
                :dense="$q.screen.xs"
                v-close-popup
            />
        </q-card-section>

        <q-space />

        <div class="DeviceEditModal-body">
            <AssetsNumberSection />
            <LoraKeySection />
            <EthalonSection />
        </div>

        <q-space />

        <q-card-section />

        <q-separator class="DeviceEditModal-separator" />

        <q-card-actions class="DeviceEditModal-footer" align="around">
            <q-btn
                class="DeviceEditModal-btn DeviceEditModal-cancel"
                v-close-popup
                outline
                color="red"
                :label="cancelBtnLabel"
                :disable="creatingDevice"
                @click="onCancelClick"
            />

            <q-btn
                class="DeviceEditModal-btn DeviceEditModal-submit"
                outline
                color="primary"
                :label="submitBtnLabel"
                :disable="!editModalReady || creatingDevice"
                :loading="creatingDevice"
                @click="onSubmitClick"
            >
                <template v-slot:loading>
                    <q-spinner-puff />
                </template>
            </q-btn>
        </q-card-actions>
    </q-card>
</template>

<script>
import AssetsNumberSection from './DeviceEditModal/AssetsNumberSection.vue';
import LoraKeySection from './DeviceEditModal/LoraKeySection.vue';
import EthalonSection from './DeviceEditModal/EthalonSection.vue';

import withShowMessage from '@mixins/withShowMessage';
import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'DeviceEditModal',
    components: {
        AssetsNumberSection,
        LoraKeySection,
        EthalonSection
    },
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('Devices', ['mobileMode', 'editModalData', 'editModalReady', 'creatingDevice', 'deviceList']),

        isEditMode() {
            let { id } = this.editModalData;

            return id !== null;
        },

        title() {
            let title = this.addTitle;
            if (this.isEditMode) title = this.editTitle;

            return title;
        },

        submitBtnLabel() {
            let label = this.addSubmitBtnTitle;
            if (this.isEditMode) label = this.editSubmitBtnTitle;

            return label;
        }
    },
    data() {
        return {
            addTitle: 'Добавление нового устройства',
            editTitle: 'Редактирование устройства',
            addSubmitBtnTitle: 'Добавить',
            editSubmitBtnTitle: 'Применить',
            cancelBtnLabel: 'Отмена',

            addSuccess: 'Устройство успешно добавлено',
            addError: 'Ошибка добавления устройства',

            editSuccess: 'Устройство успешно изменено',
            editError: 'Ошибка изменения устройства'
        };
    },
    created() {
        window.DeviceEditModal = this;
    },
    beforeDestroy() {
        this.clearEditModalData();
    },
    methods: {
        ...mapMutations('Devices', [
            'setEditModalOpen',
            'clearEditModalData',
            'updateOneDevice',
            'addOneDevice',
            'addOneDeviceMap'
        ]),
        ...mapActions('Devices', ['requestCreateDevice', 'requestEditDevice']),

        onCancelClick() {},
        async onSubmitClick() {
            // Если режим редактирования
            if (this.isEditMode) {
                let res = await this.requestEditDevice();
                if (res) {
                    this.showMessage(this.editSuccess);

                    let { id, name, loraKey } = res;
                    this.updateOneDevice({ id, name, loraKey });

                    this.setEditModalOpen();
                } else {
                    this.showMessage(this.editError, true);
                }

                // Если режим создания нового устройства
            } else {
                let res = await this.requestCreateDevice();
                if (res) {
                    this.showMessage(this.addSuccess);

                    let { rowId, name, loraKey, sendPeriod, ethalon } = res;
                    let device = {
                        id: rowId,
                        name,
                        lora_key: loraKey,
                        send_period: sendPeriod,
                        ethalon,
                        dates: [],
                        activityLevel: [],
                        altitude: [],
                        battery: [],
                        temperature: [],
                        connectTime: null,
                        currentSession: null,
                        currentZone: {},
                        owner: {
                            first_name: null,
                            id: null,
                            last_name: null,
                            surname: null
                        },
                        rawData: {}
                    };

                    let index = this.deviceList.length;

                    console.log(device, index);

                    this.addOneDevice(device);
                    this.addOneDeviceMap({
                        index,
                        id: rowId
                    });

                    this.setEditModalOpen();
                } else {
                    this.showMessage(this.addError, true);
                }
            }
        }
    }
};
</script>

<style lang="sass">
.DeviceEditModal
    display: flex
    flex-direction: column
    &-header
        @media only screen and (max-width : 599px)
            margin-top: 16px
    &-close
        position: absolute
        top: 0
        right: 0
    &-closeMobile
        top: -16px
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        margin-right: 16px
        text-align: center
    &-body
        width: 480px
        display: flex
        flex-direction: column
        align-items: center
        @media only screen and (max-width : 599px)
            max-width: none
            width: 100%
    &-deviceSection, &-workerSection, &-dateSection
        width: 100%
    &-separator
        flex-grow: 0
    &-footer
        padding: 16px 8px
        @media only screen and (max-width : 599px)
            padding: 24px 8px
    &-btn
        width: 30%
        @media only screen and (max-width : 599px)
            width: 40%
</style>
