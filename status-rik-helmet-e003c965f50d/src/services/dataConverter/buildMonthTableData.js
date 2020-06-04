import { shortName } from '@services/utils';

// Сбор строки "Итого" по дням для всех работников
// с последней ячейкой, в которой сумма по столбцу "Итого чел/час" для всех работников
const buildTotalRow = (hoursData, hoursDataKeys) => {
    let totalRow = {
        pp: {
            custom: true,
            cell_type: 'totalRowCell',
            cell: 'pp',
            value: ''
        },
        position: {
            custom: true,
            cell_type: 'totalRowCell',
            cell: 'position',
            value: ''
        },
        worker: {
            custom: true,
            cell_type: 'totalRowCell',
            cell: 'title',
            value: 'Итого'
        }
    };

    let totalExcel = 0;
    let totalDevice = 0;

    // Цикл по массиву данных работников
    hoursData.forEach(({ hours_data }) => {
        // Цикл по массиву дней одного работника
        hoursDataKeys.forEach(dayKey => {
            let { excel_hours, device_hours } = hours_data[dayKey];
            // Если в строке "Итого" еще нет ячейки за этот день, добавим ее с нулевыми значениями
            if (!totalRow[dayKey]) {
                totalRow[dayKey] = {
                    excel_hours: 0,
                    device_hours: 0
                };
            }

            // Суммируем предыдущие данные из ячейки в totalRow за текущий день с данными текущей итерации
            let { excel_hours: total_excel_hours, device_hours: total_device_hours } = totalRow[dayKey];
            totalRow[dayKey] = {
                excel_hours: total_excel_hours + excel_hours,
                device_hours: total_device_hours + device_hours
            };
        });
    });

    // Цикл по массиву дней
    hoursDataKeys.forEach(dayKey => {
        let { excel_hours, device_hours } = totalRow[dayKey];
        // Оформляем ячейки строки "Итого" с данными по дням для вывода в таблицу
        totalRow[dayKey] = {
            custom: true,
            cell_type: 'totalRowCell',
            cell: 'day',
            excel_hours: parseFloat(excel_hours.toFixed(1)),
            device_hours: parseFloat(device_hours.toFixed(1))
        };

        // Сбор данных для итоговой ячейки суммы по всем дням для всех работников
        totalExcel += excel_hours;
        totalDevice += device_hours;
    });

    totalRow.hours_total = {
        custom: true,
        cell_type: 'totalRowCell',
        cell: 'total',
        excel_hours: parseFloat(totalExcel.toFixed(1)),
        device_hours: parseFloat(totalDevice.toFixed(1))
    };

    return totalRow;
};

export default (hoursData, hoursDataKeys) => {
    let result = [];

    // Проход по массиву работников
    result = hoursData.map((data, index) => {
        let { last_name, first_name, surname, position, hours_data } = data;

        let totalExcelHours = 0;
        let totalDeviceHours = 0;
        let totalActive = false;
        let prepared_hours_data = {};

        // Проход по массиву ключей дней в объекте hours_data одного работника
        hoursDataKeys.forEach(dayKey => {
            // Количество часов из excel и с устройства за день dayKey
            let { excel_hours, device_hours, active } = hours_data[dayKey];
            if (active) totalActive = true;

            prepared_hours_data[dayKey] = {
                excel_hours: parseFloat(excel_hours.toFixed(1)),
                device_hours: parseFloat(device_hours.toFixed(1)),
                active
            };

            // Собираем сумму часов из excel и с устройств за весь период дней из hours_data одного работника
            totalExcelHours += excel_hours;
            totalDeviceHours += device_hours;
        });

        let workerShortName = shortName(last_name, first_name, surname);
        let workerFullName = `${last_name} ${first_name} ${surname}`;

        if (!position) position = { name: '' };

        let positionName = position.name;
        let positionFull = positionName.trim();
        // Берем только первое слово из названия должности
        let positionShort = positionFull.split(' ')[0];

        // Объект одной строки таблицы
        return {
            index,
            pp: index + 1,
            worker: {
                value: workerShortName,
                title: workerFullName
            },
            position: {
                value: positionShort,
                title: positionFull
            },

            // Ячейки с данными по каждому дню месяца
            ...prepared_hours_data,
            hours_total: {
                excel_hours: parseFloat(totalExcelHours.toFixed(1)),
                device_hours: parseFloat(totalDeviceHours.toFixed(1)),
                active: totalActive
            }
        };
    });

    let totalRow = buildTotalRow(hoursData, hoursDataKeys);
    totalRow.index = result.length;
    result.push(totalRow);

    // Массив строк таблицы
    return result;
};
