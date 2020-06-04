<template>
    <div class="ProjectElementDataView shadow-2" :class="{ 'ProjectElementDataView-show': isShow }">
        <q-scroll-area
            class="ProjectElementDataView-scrollArea"
            :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }"
        >
            <!-- Раскрывающийся блок связи конструктива и объекта модели -->
            <ExpandableWrap :value="isShowViewBind">
                <ProjectElementDataViewBind />
            </ExpandableWrap>
            <q-separator class="ProjectElementDataView-separator" v-if="isShowViewBind" inset />

            <!-- Заголовок -->
            <div class="ProjectElementDataView-titleMain ProjectElementDataView-title">
                {{ selectedCompleteData.constructiveName }}
            </div>
            <q-separator class="ProjectElementDataView-separator" inset />

            <!-- Объем -->
            <div class="ProjectElementDataView-volume" v-if="!isFalse(selectedCompleteData.volume)">
                <span class="ProjectElementDataView-volumeTitle">Объем:</span>
                {{ toFixed(selectedCompleteData.volume, 2) }}
                <span class="ProjectElementDataView-volumeMeasure">
                    {{ displayMeasureUnit.shortName }}
                    <q-tooltip v-if="displayMeasureUnit.name" anchor="top middle" self="bottom middle" :offset="[4, 4]">
                        {{ displayMeasureUnit.name }}
                    </q-tooltip>
                </span>
            </div>

            <!-- Стоимость -->
            <div class="ProjectElementDataView-cost" v-if="!isFalse(selectedCompleteData.cost)">
                <span class="ProjectElementDataView-costTitle">Стоимость:</span>
                {{ toFixed(selectedCompleteData.cost, 2) }}
            </div>

            <!-- Начало -->
            <div class="ProjectElementDataView-start" v-if="!isFalse(selectedCompleteData.versionStart)">
                <span class="ProjectElementDataView-startTitle">Начало:</span>
                {{ stringDateTimeFormat(selectedCompleteData.versionStart) }}
            </div>

            <!-- Окончание -->
            <div class="ProjectElementDataView-finish" v-if="!isFalse(selectedCompleteData.versionFinish)">
                <span class="ProjectElementDataView-finishTitle">Окончание:</span>
                {{ stringDateTimeFormat(selectedCompleteData.versionFinish) }}
            </div>

            <!-- Завершено -->
            <div class="ProjectElementDataView-complete" v-if="selectedCompleteData.isComplete !== null">
                <span class="ProjectElementDataView-completeTitle">Завершено:</span>
                {{ selectedCompleteData.isComplete ? 'Да' : 'Нет' }}
            </div>

            <!-- <q-separator class="ProjectElementDataView-separator" inset /> -->

            <!-- Секция "Работы" -->
            <div class="ProjectElementDataView-works" v-if="selectedCompleteData.worksArray.length > 0">
                <div class="ProjectElementDataView-title q-mt-sm">
                    Работы
                </div>
                <q-separator class="ProjectElementDataView-separator" inset />

                <!-- Массив работ -->
                <div
                    class="ProjectElementDataView-work shadow-2"
                    v-for="work in selectedCompleteData.worksArray"
                    :key="work.rowId"
                >
                    <div class="ProjectElementDataView-workTitle">{{ work.name }}</div>
                </div>
            </div>

            <!-- Секция "Ресурсы" -->
            <div class="ProjectElementDataView-resources" v-if="selectedCompleteData.resources.length > 0">
                <div class="ProjectElementDataView-title q-mt-sm">
                    Ресурсы
                </div>
                <q-separator class="ProjectElementDataView-separator" inset />

                <!-- Массив ресурсов -->
                <div
                    class="ProjectElementDataView-resource shadow-2"
                    v-for="resource in selectedCompleteData.resources"
                    :key="resource.rowId"
                >
                    <div class="ProjectElementDataView-resourceTitle">{{ resource.name }}</div>
                    <div class="ProjectElementDataView-resourcePlan" v-if="!isFalse(resource.volumePlan)">
                        <span class="ProjectElementDataView-resourcePlanTitle">Запланированный объем:</span>
                        {{ resource.volumePlan }}
                        <span class="ProjectElementDataView-resourcePlanMeasure">
                            {{ measureUnitNormalize(resource.measureUnit).shortName }}
                            <q-tooltip
                                v-if="measureUnitNormalize(resource.measureUnit).name"
                                anchor="top middle"
                                self="bottom middle"
                                :offset="[4, 4]"
                            >
                                {{ measureUnitNormalize(resource.measureUnit).name }}
                            </q-tooltip>
                        </span>
                    </div>
                </div>
            </div>

            <!-- TODO: На время теста -->
            <!-- <q-separator class="ProjectElementDataView-separator" inset />
            <DataViewer class="DataViewer" :data="viewerData" :expandDepth="2" /> -->
        </q-scroll-area>
    </div>
</template>

<script>
import ExpandableWrap from '../common/ExpandableWrap.vue';
import ProjectElementDataViewBind from '../bim/ProjectElementDataViewBind.vue';
import DataViewer from '../common/DataViewer.vue';

import isFalse from '@services/utils/isFalse';
import toFixed from '@services/utils/toFixed';
import measureUnitNormalize from '@services/utils/measureUnitNormalize';
import stringDateTimeFormat from '@services/utils/dateUtils/stringDateTimeFormat';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'ProjectElementDataView',
    components: {
        ExpandableWrap,
        ProjectElementDataViewBind,
        DataViewer
    },
    data() {
        return {
            toFixed,
            isFalse,
            stringDateTimeFormat,
            measureUnitNormalize
        };
    },
    computed: {
        ...mapGetters('Bim', ['selectedProjectElement', 'selectedMetaObject', 'selectedCompleteData']),

        isShow() {
            return this.selectedCompleteData.constructiveId;
        },

        isShowViewBind() {
            return !!(
                this.selectedProjectElement &&
                this.selectedProjectElement.rowId &&
                this.selectedMetaObject && this.selectedMetaObject.id
            );
        },

        displayMeasureUnit() {
            return measureUnitNormalize(this.selectedCompleteData.measureUnit);
        },

        // TODO: На время теста
        viewerData() {
            return this.selectedCompleteData;
        }
    },
    watch: {
        selectedCompleteData: {
            handler(newData, oldData) {
                // Если в наборе новых данных есть constructiveId,
                // (был выбран элемент из дерева конструктивов в ProjectElementsTree)
                // и либо нет старых данных, либо constructiveId у новых и старых данных различается
                if (
                    newData &&
                    newData.constructiveId &&
                    (!oldData || newData.constructiveId !== oldData.constructiveId)
                ) {
                    // Запросим по constructiveId список работ
                    this.requestWorks();

                    return;
                }

                // Если в наборе новых данных не было constructiveId, но есть appId,
                // (был выбран объект модели)
                // и либо нет старых данных, либо appId у новых и старых данных различается
                if (newData && newData.appId && (!oldData || newData.appId !== oldData.appId)) {
                    // Запросим по appId данные о конструктиве
                    this.requestConstructiveByAppId();
                }
            },
            deep: true
        }
    },
    methods: {
        ...mapActions('Bim', ['requestWorks', 'requestConstructiveByAppId'])
    }
};
</script>

<style lang="sass">
.ProjectElementDataView
    background-color: rgba(255, 255, 255, 0.7)
    backdrop-filter: blur(3px)
    border-radius: 4px
    position: absolute
    right: 0
    top: 0
    bottom: 0
    width: 350px
    max-width: 350px
    // padding: 8px
    overflow: auto
    transform: translateX(100%)
    transition: opacity 100ms 150ms ease-in-out, transform 250ms ease-in-out
    &-show
        opacity: 1
        transform: translateX(0)
        transition: opacity 100ms ease-in-out, transform 250ms ease-in-out
    &-scrollArea
        height: 100%
        padding: 8px
    //     & > .scroll > .absolute.full-width
    //         height: 100%
    //         display: flex
    //         flex-direction: column
    &-separator
        margin: 8px 0

    &-title
        font-weight: bold
        color: var(--ms-grey)
    &-titleMain
        color: var(--ms-primary)
    &-volumeTitle,
    &-costTitle,
    &-startTitle,
    &-finishTitle,
    &-completeTitle
        font-size: 14px
        font-weight: bold

    &-resourcePlanTitle
        font-size: 13px
        color: var(--ms-grey)

    &-work,
    &-resource
        padding: 8px
        margin: 4px
        border-radius: 4px

    // TODO: На время теста
    .DataViewer
        height: 100%
        min-height: 400px
        display: flex
        flex-direction: column
        box-shadow: none
        background-color: transparent !important
        & > .scroll
            flex-grow: 1
        .jv-container.jv-light
            background-color: transparent !important
        .DataViewer-code.jv-container .jv-code
            padding: 0
</style>
