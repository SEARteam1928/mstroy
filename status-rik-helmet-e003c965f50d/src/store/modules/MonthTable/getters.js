import buildMonthTableData from '@services/dataConverter/buildMonthTableData';
import { date as quasarDate } from 'quasar';

export const projectId = state => state.projectId;
export const periodDate = state => state.periodDate;

export const currentMonth = state =>
    state.periodDate.to ? quasarDate.formatDate(new Date(state.periodDate.to), 'MMMM') : '';
export const currentYear = state =>
    state.periodDate.to ? quasarDate.formatDate(new Date(state.periodDate.to), 'YYYY') : '';

export const hoursData = state => state.hoursData;

// Получаем данные по дням с первого работника, из этих данных соберем массив строковых ключей в объекте hours_data.
// У всех работников должно быть одинаковое количество дней в hours_data
export const hoursDataKeys = state => {
    let result = [];
    if (!state.hoursData[0] || state.hoursData.length === 0) return result;

    let hoursData = state.hoursData[0].hours_data;
    result = Object.keys(hoursData);

    return result;
};
export const tableModel = (state, getters) => {
    // Первые столбцы таблицы
    let modelPrefix = [
        {
            name: 'pp',
            label: '№\nп/п',
            field: 'pp',
            align: 'center'
        },
        {
            name: 'worker',
            label: 'ФИО\nсотрудников',
            field: 'worker',
            align: 'left'
        },
        {
            name: 'position',
            label: 'Должность',
            field: 'position',
            align: 'left'
        }
    ];

    // Последний столбец таблицы
    let modelPostfix = [
        {
            name: 'hours_total',
            label: 'Итого\nчел/час',
            field: 'hours_total',
            align: 'center'
        }
    ];

    let result = [];
    let daysColumn = [];

    if (state.hoursData.length === 0) {
        return modelPrefix.concat(modelPostfix);
    }

    // Проходим по ключам данных по дням, собрав из них часть модели таблицы
    daysColumn = getters.hoursDataKeys.map(key => {
        // Из строки с датой в формате DD/MM/YYYY берет DD для отображения в шапке столбцов таблицы
        let dayKey = key.split('/')[0];

        return {
            name: key,
            label: dayKey,
            field: key,
            align: 'center'
        };
    });

    // Собираем вместе модель таблицы
    result = modelPrefix.concat(daysColumn, modelPostfix);

    return result;
};

// Сбор данных в формате, нужном для отображения в таблице
export const tableData = (state, getters) => {
    let result = [];
    if (getters.hoursDataKeys.length === 0) return result;

    result = buildMonthTableData(state.hoursData, getters.hoursDataKeys);

    // Массив строк таблицы
    return result;
};

export const dataIsLoading = state => state.dataIsLoading;

// Для обработки ошибок
export const moduleErrors = state => {
    let errors = {};
    Object.keys(state.moduleErrors).forEach(err => {
        let error = state.moduleErrors[err];
        if (error) errors[err] = error;
    });

    return errors;
};
export const showErrors = (state, getters) => {
    return JSON.stringify(getters.moduleErrors, ' ', 4);
};
