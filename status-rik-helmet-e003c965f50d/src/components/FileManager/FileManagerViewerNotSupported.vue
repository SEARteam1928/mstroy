<template>
    <q-card class="FileManagerViewerNotSupported">
        <q-card-section class="FileManagerViewerNotSupported-header">
            <div class="FileManagerViewerNotSupported-title">{{ fileName }}</div>
        </q-card-section>

        <q-card-section class="row items-center no-wrap">
            <q-avatar color="primary" text-color="white">
                <QIconCustom name="file-times" :colors="{ primary: '#fff' }" />
            </q-avatar>
            <span class="q-ml-sm">Просмотр файлов этого типа не поддерживается</span>
        </q-card-section>

        <q-card-actions class="FileManagerViewerNotSupported-actions" align="right">
            <q-btn class="FileManagerViewerNotSupported-close" flat color="red" label="Закрыть" v-close-popup />
        </q-card-actions>
    </q-card>
</template>

<script>
import QIconCustom from '../common/QIconCustom.vue';

export default {
    name: 'FileManagerViewerNotSupported',
    components: {
        QIconCustom
    },
    props: {
        file: {
            validator: prop => prop instanceof Object || prop === null
        }
    },
    computed: {
        fileName() {
            let name = '';
            if (this.file) name = this.file.name;

            return name;
        }
    }
};
</script>

<style lang="sass">
.FileManagerViewerNotSupported
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        margin-right: 16px
        text-align: center
    &-close
</style>
