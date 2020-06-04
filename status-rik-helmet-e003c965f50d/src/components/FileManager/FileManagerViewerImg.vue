<template>
    <div class="FileManagerViewerImg" :class="{ loading }">
        <q-img
            v-if="url"
            class="FileManagerViewerImg-content"
            contain
            height="100%"
            width="100%"
            :src="url"
            @load="onLoad"
            @error="onError"
        >
            <template v-slot:error>
                <div class="FileManagerViewerImg-error">Не удалось загрузить изображение</div>
            </template>
        </q-img>
    </div>
</template>

<script>
export default {
    name: 'FileManagerViewerImg',
    props: {
        viewerData: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            loading: false
        };
    },
    computed: {
        url() {
            return this.viewerData.currentFileUrl;
        }
    },
    watch: {
        url(newUrl) {
            this.loading = true;
        }
    },
    methods: {
        onLoad() {
            this.loading = false;
        },
        onError(e) {
            this.loading = false;
        }
    }
};
</script>

<style lang="sass">
.FileManagerViewerImg
    &-error
        position: absolute
        padding: 16px
        top: 50%
        left: 50%
        transform: translate(-50%, -50%)
        border-radius: 4px

    .q-img__image
        opacity: 1
        transition: opacity 300ms ease-in
    &.loading
        .q-img__image
            opacity: 0.7
            transition: opacity 300ms ease-out
</style>
