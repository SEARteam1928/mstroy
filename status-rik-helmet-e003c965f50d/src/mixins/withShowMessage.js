export default () => {
    return {
        methods: {
            showMessage(message, error) {
                this.$q.notify({
                    icon: error ? 'close' : 'done',
                    color: error ? 'ms-red' : 'ms-blue',
                    message
                });
            }
        }
    };
};
