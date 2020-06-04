<template>
    <q-card class="HeaderProjectSelector">
        <q-card-section class="HeaderProjectSelectorFilter-section">
            <HeaderProjectSelectorFilter />
        </q-card-section>

        <q-card-section class="HeaderProjectSelectorProjectsList-section">
            <HeaderProjectSelectorProjectsList />
        </q-card-section>
    </q-card>
</template>

<script>
import HeaderProjectSelectorFilter from './HeaderProjectSelectorFilter.vue';
import HeaderProjectSelectorProjectsList from './HeaderProjectSelectorProjectsList.vue';

export default {
    name: 'HeaderProjectSelector',
    components: {
        HeaderProjectSelectorFilter,
        HeaderProjectSelectorProjectsList
    }
};
</script>

<style lang="sass">
.HeaderProjectSelector
    max-height: 600px
    height: 80vh
    display: flex
    flex-direction: column
    flex-grow: 1
    .HeaderProjectSelectorFilter-section
        padding-top: 0
        padding-bottom: 0
    .HeaderProjectSelectorProjectsList-section
        display: flex
        flex-direction: column
        flex-grow: 1
        padding-right: 0
</style>
