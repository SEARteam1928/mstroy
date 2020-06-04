<template>
    <canvas ref="BimNavCube" id="BimNavCube" />
</template>

<script>
import { NavCubePlugin } from '@xeokit/xeokit-sdk/src/plugins/NavCubePlugin/NavCubePlugin.js';

export default {
    props: ['viewer', 'activated'],
    data() {
        return {
            navCube: null
        };
    },
    mounted() {
        this.init();
    },
    methods: {
        init(viewer = this.viewer) {
            if (!viewer || !this.$refs.BimNavCube) return;
            this.navCube = new NavCubePlugin(viewer, {
                canvasElement: this.$refs.BimNavCube,
                visible: true,
                cameraFly: true,
                cameraFitFOV: 45,
                cameraFlyDuration: 0.5,
                fitVisible: false,
                synchProjection: false,
                color: 'lightgrey'
            });
        }
    },
    watch: {
        viewer(newViewer) {
            this.init(newViewer);
        }
    }
};
</script>

<style lang="sass">
#BimNavCube
    position: absolute
    width: 100px
    height: 100px
    bottom: 20px
    right: 20px
</style>
