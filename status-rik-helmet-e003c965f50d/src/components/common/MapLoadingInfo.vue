<template>
    <l-control
        v-if="!isHide"
        :position="position"
        ref="control"
        class="leaflet-control leaflet-control-layers MapLoadingInfo"
    >
        <!-- Идет загрузка -->
        <div v-if="status === 'loading'" class="MapLoadingInfo-status MapLoadingInfo-status-loading">
            <q-spinner-puff class="MapLoadingInfo-status-icon" />
            <div class="MapLoadingInfo-status-text">{{ _loadingText }}</div>
        </div>

        <!-- Нет данных -->
        <div v-if="status === 'nodata'" class="MapLoadingInfo-status MapLoadingInfo-status-nodata">
            <q-icon class="MapLoadingInfo-status-icon" name="error" />
            <div class="MapLoadingInfo-status-text">{{ _nodataText }}</div>
        </div>

        <!-- Не выбрана дата -->
        <div v-if="status === 'nodate'" class="MapLoadingInfo-status MapLoadingInfo-status-nodate">
            <q-icon class="MapLoadingInfo-status-icon" name="event_busy" />
            <div class="MapLoadingInfo-status-text">{{ _nodateText }}</div>
        </div>

        <!-- Ошибка -->
        <div v-if="status === 'error'" class="MapLoadingInfo-status MapLoadingInfo-status-error">
            <q-icon class="MapLoadingInfo-status-icon" name="warning" />
            <div class="MapLoadingInfo-status-text">{{ _errorText }}</div>
        </div>
    </l-control>
</template>

<script>
import { LControl } from 'vue2-leaflet';

export default {
    name: 'MapLoadingInfo',
    props: {
        position: {
            type: String,
            required: false,
            default: 'topright'
        },
        status: {
            type: String,
            required: true
        },
        statusText: {
            type: String,
            required: false
        }
    },
    components: {
        LControl
    },
    computed: {
        isHide() {
            if (this.status === 'hide') return true;
            if (!this.allowStatus.includes(this.status)) return true;

            return false;
        },
        _loadingText() {
            let text = this.loadingText;
            if (this.status === 'loading' && this.statusText) text = this.statusText;

            return text;
        },
        _nodataText() {
            let text = this.nodataText;
            if (this.status === 'nodata' && this.statusText) text = this.statusText;

            return text;
        },
        _nodateText() {
            let text = this.nodateText;
            if (this.status === 'nodate' && this.statusText) text = this.statusText;

            return text;
        },
        _errorText() {
            let text = this.errorText;
            if (this.status === 'error' && this.statusText) text = this.statusText;

            return text;
        }
    },
    created() {
        window.MapLoadingInfo = this;
    },
    data() {
        return {
            allowStatus: ['hide', 'loading', 'nodata', 'nodate', 'error'],
            loadingText: 'Идет загрузка данных',
            nodataText: 'Нет данных',
            nodateText: 'Не выбрана дата',
            errorText: 'Ошибка загрузки данных'
        };
    }
};
</script>

<style lang="sass">
.MapLoadingInfo
    padding: 5px 10px
    &-status
        height: 20px
        display: flex
        align-items: center
        &-icon
            margin-right: 5px
            color: rgba(0,0,0,0.54)
            font-size: 20px
</style>
