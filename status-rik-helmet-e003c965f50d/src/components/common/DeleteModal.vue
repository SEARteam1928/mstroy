<template>
    <q-dialog
        :value="value_"
        :persistent="wait"
        @input="$emit('input', $event)"
        @before-show="$emit('before-show', $event)"
        @show="$emit('show', $event)"
        @before-hide="$emit('before-hide ', $event)"
        @hide="$emit('hide', $event)"
    >
        <q-card class="DeleteModal">
            <q-card-section class="DeleteModal-header">
                <div class="DeleteModal-title">{{ title }}</div>
            </q-card-section>

            <q-card-section class="row items-center no-wrap">
                <q-avatar icon="delete" color="primary" text-color="white" />
                <span class="q-ml-sm">{{ text }}</span>
            </q-card-section>

            <q-card-actions class="DeleteModal-actions" align="right">
                <q-btn
                    class="DeleteModal-cancel"
                    flat
                    color="primary"
                    :label="cancelText"
                    :disable="wait"
                    @click="onCancel"
                />
                <q-btn
                    class="DeleteModal-submit"
                    flat
                    color="red"
                    :label="submitText"
                    :disable="wait"
                    :loading="wait"
                    @click="onSubmit"
                >
                    <template v-slot:loading>
                        <q-spinner-puff />
                    </template>
                </q-btn>
            </q-card-actions>
        </q-card>
    </q-dialog>
</template>

<script>
export default {
    name: 'DeleteModal',
    props: {
        value: {
            type: Boolean,
            required: false,
            default: false
        },
        title: {
            type: String,
            required: true
        },
        text: {
            type: String,
            required: true
        },
        cancelText: {
            type: String,
            required: false,
            default: 'Отмена'
        },
        submitText: {
            type: String,
            required: false,
            default: 'Удалить'
        },
        wait: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    data() {
        return {
            value_: false
        };
    },
    watch: {
        value: {
            handler(newValue) {
                this.value_ = newValue;
            },
            immediate: true
        }
    },
    methods: {
        open() {
            this.value_ = true;
            this.$emit('input', true);
        },
        close() {
            this.value_ = false;
            this.$emit('input', false);
        },

        onSubmit() {
            this.$emit('submit');
        },
        onCancel() {
            this.$emit('cancel');
            this.close();
        }
    }
};
</script>

<style lang="sass">
.DeleteModal
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        margin-right: 16px
        text-align: center
</style>
