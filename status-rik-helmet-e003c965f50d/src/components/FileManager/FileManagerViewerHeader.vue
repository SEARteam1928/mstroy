<template>
    <q-card-section class="FileManagerViewerHeader" :class="{ mobileMode }">
        <div v-if="hasIndexInfo" class="FileManagerViewerHeader-index">
            [
            <div class="FileManagerViewerHeader-indexCurrent">{{ viewerData.currentIndex + 1 }}</div>
            /
            <div class="FileManagerViewerHeader-indexTotal">{{ viewerData.total }}</div>
            ]
        </div>

        <q-btn
            v-if="fileName"
            class="FileManagerViewerHeader-download"
            flat
            round
            dense
            color="primary"
            icon="get_app"
            @click="$emit('download')"
        />

        <div class="FileManagerViewerHeader-title">{{ fileName }}</div>

        <CloseModal :mobileMode="mobileMode" />
    </q-card-section>
</template>

<script>
import CloseModal from '@components/common/CloseModal.vue';

export default {
    name: 'FileManagerViewerHeader',
    components: {
        CloseModal
    },
    props: {
        mobileMode: {
            type: Boolean,
            required: false,
            default: false
        },
        viewerData: {
            type: Object,
            required: true
        }
    },
    computed: {
        fileName() {
            let name = '';
            let { currentFileName } = this.viewerData;
            if (currentFileName) name = currentFileName;

            return name;
        },
        hasIndexInfo() {
            return this.viewerData.total > 1;
        }
    }
};
</script>

<style lang="sass">
.FileManagerViewerHeader
    position: relative
    display: flex
    align-items: center
    padding: 5px 16px
    height: 30px
    background-color: #fff
    &-index
        display: flex
        margin-right: 10px
    &-title
        font-weight: 600
        margin-right: 44px
        white-space: nowrap
        overflow: hidden
        text-overflow: ellipsis
    &-download
        font-size: 12px
        margin-right: 2px

    &.mobileMode
        .FileManagerViewerHeader
            &-title
                margin-right: 22px
</style>
