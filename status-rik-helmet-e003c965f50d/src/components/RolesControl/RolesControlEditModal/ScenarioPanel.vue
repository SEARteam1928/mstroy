<template>
    <div class="ScenarioPanel">
        <ScenarioSection />
    </div>
</template>

<script>
import ScenarioSection from './ScenarioSection.vue';

export default {
    name: 'ScenarioPanel',
    components: {
        ScenarioSection
    }
};
</script>

<style lang="sass">
.ScenarioPanel
    height: 100%
    display: flex
    flex-direction: column
    overflow: hidden
</style>
