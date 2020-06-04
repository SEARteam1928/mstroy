<template>
    <div class="SingleSelectedInfo">
        <div class="SingleSelectedInfo-section fullName">
            <div class="SingleSelectedInfo-sectionTitle">Полное название</div>
            <div class="SingleSelectedInfo-sectionValue" v-if="fullName">{{ fullName }}</div>
            <div class="SingleSelectedInfo-sectionValue nullValueText" v-if="!fullName">{{ nullValueText }}</div>
        </div>

        <div class="SingleSelectedInfo-section shortName">
            <div class="SingleSelectedInfo-sectionTitle">Короткое название</div>
            <div class="SingleSelectedInfo-sectionValue" v-if="shortName">{{ shortName }}</div>
            <div class="SingleSelectedInfo-sectionValue nullValueText" v-if="!shortName">{{ nullValueText }}</div>
        </div>

        <div class="SingleSelectedInfo-section dates">
            <div class="SingleSelectedInfo-sectionTitle">Даты строительства</div>
            <div class="SingleSelectedInfo-sectionValue" v-if="dates">{{ dates }}</div>
            <div class="SingleSelectedInfo-sectionValue nullValueText" v-if="!dates">{{ nullValueText }}</div>
        </div>

        <div class="SingleSelectedInfo-section cost">
            <div class="SingleSelectedInfo-sectionTitle">Цена контракта</div>
            <div class="SingleSelectedInfo-sectionValue" v-if="cost">{{ cost }}</div>
            <div class="SingleSelectedInfo-sectionValue nullValueText" v-if="!cost">{{ nullValueText }}</div>
        </div>

        <div class="SingleSelectedInfo-section characteristics">
            <div class="SingleSelectedInfo-sectionTitle">Краткие технически характеристики</div>
            <div class="SingleSelectedInfo-sectionValue" v-if="characteristics">{{ characteristics }}</div>
            <div class="SingleSelectedInfo-sectionValue nullValueText" v-if="!characteristics">{{ nullValueText }}</div>
        </div>

        <div class="SingleSelectedInfo-section timezone">
            <div class="SingleSelectedInfo-sectionTitle">Часовой пояс</div>
            <div class="SingleSelectedInfo-sectionValue" v-if="timezone">{{ timezone }}</div>
            <div class="SingleSelectedInfo-sectionValue nullValueText" v-if="!timezone">{{ nullValueText }}</div>
        </div>

        <div class="SingleSelectedInfo-section coords">
            <div class="SingleSelectedInfo-sectionTitle">Координаты проекта</div>
            <div class="SingleSelectedInfo-sectionValue" v-if="coords">{{ coords }}</div>
            <div class="SingleSelectedInfo-sectionValue nullValueText" v-if="!coords">{{ nullValueText }}</div>
        </div>
    </div>
</template>

<script>
import dateParse from '@services/utils/dateUtils/parse';
import isFalse from '@services/utils/isFalse';

import { date as quasarDate } from 'quasar';

export default {
    name: 'SingleSelectedInfo',
    props: {
        project: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            dateMask: 'DD.MM.YYYY',
            nullValueText: 'Нет информации'
        };
    },
    computed: {
        fullName() {
            return this.project.name;
        },
        shortName() {
            return this.project.shortName;
        },
        dates() {
            let result = '';
            let dateBegin = this.project.dateBegin;
            let dateComplete = this.project.dateComplete;

            result += dateBegin ? quasarDate.formatDate(dateParse(dateBegin), this.dateMask) : '';
            result += dateComplete ? ' - ' + quasarDate.formatDate(dateParse(dateComplete), this.dateMask) : '';

            return result;
        },
        cost() {
            return this.project.cost;
        },
        characteristics() {
            return this.project.characteristics;
        },
        timezone() {
            let timeZoneOffset = this.project.timeZoneOffset;
            if (isFalse(timeZoneOffset)) return null;

            let timezone = parseInt(timeZoneOffset) / 60;
            timezone = timezone > 0 ? `+${timezone}` : `-${timezone}`;
            timezone += ` (${timeZoneOffset}мин.)`;

            return timezone;
        },
        coords() {
            let result = '';
            let latitude = this.project.latitude;
            let longitude = this.project.longitude;

            result += latitude ? latitude : '';
            result += longitude ? ', ' + longitude : '';

            return result;
        }
    }
};
</script>

<style lang="sass">
.SingleSelectedInfo
    padding: 12px
    &-section
        padding-bottom: 8px
    &-sectionTitle
        font-weight: bold
    &-sectionValue
        padding: 0 8px
        line-height: 20px
        min-height: 20px
        &.nullValueText
            opacity: 0.5
            user-select: none
</style>
