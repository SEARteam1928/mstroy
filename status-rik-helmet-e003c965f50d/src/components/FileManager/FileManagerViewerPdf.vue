<template>
    <div class="FileManagerViewerPdf">
        <iframe class="FileManagerViewerPdf-content" v-if="src" :src="src" allowfullscreen frameborder="no" />

        <q-inner-loading :showing="loading">
            <q-spinner size="3.5em" />
        </q-inner-loading>
    </div>
</template>

<script>
import Api from '@services/api';

export default {
    name: 'FileManagerViewerPdf',
    props: {
        viewerData: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            src: null,
            loading: false
        };
    },
    computed: {
        url() {
            return this.viewerData.currentFileUrl;
        }
    },
    watch: {
        async url(newUrl) {
            this.loading = true;

            this.src = await this.createObjectURL(newUrl);
        }
    },
    methods: {
        async createObjectURL(url) {
            let res = await Api.getFileContent(url);
            let objectUrl = window.URL.createObjectURL(res);
            this.loading = false;

            return objectUrl;
        }
    }
};
</script>

<style lang="sass">
.FileManagerViewerPdf
    position: relative
    &-content
        width: 100%
        height: 100%
</style>
