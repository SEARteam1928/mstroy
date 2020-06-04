export default [{
    name: 'StartTime',
    label: 'Начало',
    field: 'StartTime',
    sortable: true,
    align: 'left',
    format: (val, row) => `${new Date(+val).toLocaleDateString()} ${new Date(+val).toLocaleTimeString()}`,
}, {
    name: 'EndTime',
    label: 'Окончание',
    field: 'EndTime',
    sortable: true,
    align: 'left',
    format: (val, row) => `${new Date(+val).toLocaleDateString()} ${new Date(+val).toLocaleTimeString()}`,
}, {
    name: 'Accepted',
    label: 'Принято (мин.)',
    field: 'Accepted',
    sortable: true,
    align: 'left',
}, {
    name: 'Total',
    label: 'Общее время  (мин.)',
    field: 'Total',
    sortable: true,
    align: 'left',
}]
