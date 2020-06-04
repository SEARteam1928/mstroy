<template>
    <div class="RolePanel">
        <NameSection />
        <DescriptionSection />
    </div>
</template>

<script>
import NameSection from './NameSection.vue';
import DescriptionSection from './DescriptionSection.vue';

export default {
    name: 'RolePanel',
    components: {
        NameSection,
        DescriptionSection
    }
};
</script>
