<template>
    <div class="DeviceTopBarLegend">
        <div class="DeviceTopBarLegend-section">Текущая зона</div>
        <div class="DeviceTopBarLegend-section">Активность</div>
        <div class="DeviceTopBarLegend-section">Батарея</div>
        <div class="DeviceTopBarLegend-section">Температура</div>
        <div class="DeviceTopBarLegend-section">Высота</div>
    </div>
</template>

<script>
export default {
    name: 'DeviceTopBarLegend'
};
</script>

<style lang="sass">
.DeviceTopBarLegend
    display: flex
    justify-content: space-between
    padding-bottom: 3px
    border-bottom: 1px solid rgba(0,0,0,0.24);
    &-section
        text-align: center
        width: 100%
        min-width: 124px
        margin: 0 3px
</style>
