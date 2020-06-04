<template>
    <div class="MonitoringChartTooltip">
        <transition name="MonitoringChartTooltip-fade">
            <div v-if="show" class="MonitoringChartTooltip-content">
                <div class="MonitoringChartTooltip-date">{{ date }}</div>
                <div class="MonitoringChartTooltip-value">{{ value }}{{ unit }}</div>
            </div>
        </transition>
    </div>
</template>

<script>
export default {
    name: 'MonitoringChartTooltip',
    props: {
        date: {
            type: [Date, String],
            required: true
        },
        value: {
            type: [Number, String],
            required: true
        },
        show: {
            type: Boolean,
            required: false,
            default: true
        },
        unit: {
            type: String,
            required: false,
            default: ''
        }
    }
};
</script>

<style lang="sass">
.MonitoringChartTooltip
    &-content
        height: 24px
        padding: 0 8px 2px
        display: flex
        align-items: flex-end
        justify-content: flex-end
        border-radius: 4px
        background-color: var(--ms-light-grey)
    &-date
        font-size: 12px
        line-height: 16px
        font-weight: normal
        color: var(--ms-grey)
    &-value
        font-size: 14px
        line-height: 18px
        color: var(--ms-dark)
        padding-left: 8px

    &-fade-enter-active, &-fade-leave-active
        transition: opacity 250ms ease-in-out
    &-fade-enter, &-fade-leave-to
        opacity: 0
</style>
