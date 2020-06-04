<template>
    <div class="ProjectElementDataViewBind">
        <div class="ProjectElementDataViewBind-item">
            <span class="ProjectElementDataViewBind-itemTitle">Конструктив:</span>
            <span class="ProjectElementDataViewBind-itemName">{{ constructiveName }}</span>
        </div>

        <div class="ProjectElementDataViewBind-item">
            <span class="ProjectElementDataViewBind-itemTitle">Объект:</span>
            <span class="ProjectElementDataViewBind-itemName">{{ objectName }}</span>
        </div>

        <div class="ProjectElementDataViewBind-actions">
            <q-btn
                class="ProjectElementDataViewBind-bindBtn"
                flat
                color="ms-primary"
                label="Связать"
                @click="onBindBtnClick"
            />
        </div>
    </div>
</template>

<script>
import withShowMessage from '@mixins/withShowMessage';

import { mapGetters, mapActions } from 'vuex';

export default {
    name: 'ProjectElementDataViewBind',
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('Bim', ['selectedProjectElement', 'selectedMetaObject', 'actualTransactionId']),

        constructiveName() {
            let name = '';

            if (this.selectedProjectElement && this.selectedProjectElement.name) {
                name = this.selectedProjectElement.name;
            }

            return name;
        },
        objectName() {
            let name = '';

            if (this.selectedMetaObject && this.selectedMetaObject.name) {
                name = this.selectedMetaObject.name;
            }

            return name;
        }
    },
    methods: {
        ...mapActions('Bim', ['requestUpdateConstructiveVersion']),

        async onBindBtnClick() {
            let id = this.selectedProjectElement.constructiveVersions[0].rowId;
            let appId = this.selectedMetaObject.id;

            let res = await this.requestUpdateConstructiveVersion({ id, appId });
            if (res && res.ok) {
                this.showMessage('Данные успешно связаны');
            }
        }
    }
};
</script>

<style lang="sass">
.ProjectElementDataViewBind
    &-item
        padding-bottom: 4px
    &-itemTitle
        font-weight: bold
        display: inline-block
        padding-right: 4px
    &-itemName
    &-actions
        display: flex
        justify-content: center
</style>
