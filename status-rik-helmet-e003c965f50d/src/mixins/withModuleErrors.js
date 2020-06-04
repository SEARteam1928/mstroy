import withShowMessage from './withShowMessage';

import { mapGetters } from 'vuex';

export default moduleName => {
    return {
        mixins: [withShowMessage()],
        watch: {
            moduleErrors(newErrors, oldErrors) {
                // При разработке будут всплывать уведомления с ошибками
                if (process.env.DEV) {
                    // Для нахождения свежей ошибки в объекте ошибок
                    let newCopyErrors = { ...newErrors };
                    Object.keys(oldErrors).forEach(err => delete newCopyErrors[err]);

                    // Если ошибки нет, значит watch сработал на очистку одной из прошлых ошибок
                    if (!Object.keys(newCopyErrors).length) return;

                    console.log(`${moduleName} Error: `, newCopyErrors);
                    let [type, error] = Object.entries(newCopyErrors)[0];

                    this.showMessage(`[ ${type} ]: ${String(error)}`, true);
                }
            }
        },
        computed: {
            ...mapGetters(moduleName, ['moduleErrors'])
        }
    };
};
