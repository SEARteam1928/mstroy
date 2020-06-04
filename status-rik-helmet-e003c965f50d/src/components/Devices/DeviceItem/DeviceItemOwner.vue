<template>
    <div class="DeviceItem-section DeviceItem-DeviceItemOwner" ref="section">
        <div class="DeviceItem-sectionHeader DeviceItem-headerOwner">
            <div v-if="mobileMode" class="DeviceItem-sectionTitle">Владелец</div>
            <div class="DeviceItem-sectionValue">{{ ownerShortName }}</div>
        </div>
        <div class="DeviceItem-sectionHeader DeviceItem-headerConnectTime">
            <div v-if="mobileMode" class="DeviceItem-sectionTitle">Соединение</div>
            <div class="DeviceItem-sectionValue">{{ time }}</div>
        </div>
    </div>
</template>

<script>
import { date } from 'quasar';

import { detectDiffTimeUnit } from '@services/utils';
import withState from './withState';

import { mapGetters } from 'vuex';

export default {
    name: 'DeviceItemOwner',
    mixins: [withState()],
    props: {
        owner: {
            type: Object,
            required: true,
            default: () => ({})
        },
        connectTime: {
            type: String,
            required: false,
            default: ''
        },
        uid: {
            type: String,
            required: false,
            default: ''
        }
    },
    data() {
        return {
            time: null,
            formatMask: 'YYYY-MM-DD HH:mm:ssZ'
        };
    },
    watch: {
        // uid после каждого запроса данных генерируется новый, используем его для определения того,
        // что данные обновлялись, даже если время последнего соединения с устройством не изменилось,
        // после запроса данных пересчитаем разницу с текущим временем
        uid() {
            this.$nextTick(() => {
                this.time = this.computeTime();
            });
        },
        connectTime: {
            handler(newTime) {
                this.time = this.computeTime(newTime);
            },
            immediate: true
        }
    },
    computed: {
        ...mapGetters('Devices', ['mobileMode']),

        // ФИО владельца устройства
        ownerShortName() {
            let name = '';
            let { last_name, first_name, surname } = this.owner;

            if (last_name) name += last_name;
            if (first_name) name += ` ${first_name[0].toUpperCase()}.`;
            if (surname) name += `${surname[0].toUpperCase()}.`;

            return name;
        }
    },
    methods: {
        // Считает разницу между текущим временем и последним соединением с устройством
        computeTime(newTime = this.connectTime) {
            let result = '';

            if (!newTime) return result;

            // https://regex101.com/r/SoMxSm/2/
            newTime = newTime.replace(/\.\d+/, '');
            let now = new Date();

            let lastTS = new Date(newTime);
            let { unit, displayUnit } = detectDiffTimeUnit(now, lastTS);
            let diff = date.getDateDiff(now, lastTS, unit);

            // let lastTS2 = date.extractDate(newTime, this.formatMask);
            // let { unit, displayUnit } = detectDiffTimeUnit(now, lastTS2);
            // let diff = date.getDateDiff(now, lastTS2, unit);

            // console.table({
            //     newTime,
            //     lastTS,
            //     '+lastTS': +lastTS,
            //     lastTS2,
            //     '+lastTS2': +lastTS2
            // });

            result = diff + displayUnit;

            return result;
        }
    }
};
</script>

<style lang="sass">
.DeviceItem-section
    &.DeviceItem-DeviceItemOwner
        flex-direction: row
        align-items: center
        &:before
            border-color: transparent
        .DeviceItem
            &-sectionHeader
                justify-content: space-between
            &-headerOwner
                .DeviceItem-sectionValue
                    color: inherit
</style>
