<template>
    <canvas ref="BimSectionPlaneCanvas" id="BimSectionPlaneCanvas" />
</template>

<script>
// import { SectionPlanesPlugin } from '@xeokit/xeokit-sdk/src/plugins/SectionPlanesPlugin/SectionPlanesPlugin.js';
// import { SkyboxesPlugin } from '@xeokit/xeokit-sdk/src/plugins/SkyboxesPlugin/SkyboxesPlugin.js';

// export default {
//     props: ['viewer', 'visible'],
//     data() {
//         return {
//             sectionPlanes: null
//         };
//     },
//     mounted() {
//         this.init();
//     },
//     beforeUnmount() {
//         // this.destroy();
//     },
//     methods: {
//         init(viewer = this.viewer) {
//             console.log(this.visible);
//             if (!viewer) return;
//             this.sectionPlanes = new SectionPlanesPlugin(this.viewer, {
//                 overviewCanvasId: 'BimSectionPlaneCanvas',
//                 overviewVisible: true
//             });

//             this.sectionPlanes.createSectionPlane({
//                 id: 'SectionPlane',
//                 pos: [0.0, 0.0, 0.0],
//                 dir: [1.0, 0.0, 0.0]
//             });
//             this.sectionPlanes.getOverviewVisible();
//         },
//         destroy() {
//             if (!this.sectionPlanes) return;
//             // this.sectionPlanes.clear();
//             // this.sectionPlanes.destroy();
//         }
//     },
//     watch: {
//         visible(newVisible) {}
//     }
// };
</script>

<style lang="sass">
#BimSectionPlaneCanvas
    position: absolute
    width: 150px
    height: 150px
    bottom: 20px
    left: 20px
</style>
