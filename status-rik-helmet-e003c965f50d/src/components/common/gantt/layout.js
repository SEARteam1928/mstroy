let resourceGridColumns = {
    columns: [
        {
            name: 'start_date',
            label: `<div title="Начало">Начало</div>`,
            align: 'center',
            // resize: true,
            min_width: 80,
            template: task => task.start_date
        },
        {
            name: 'end_date',
            label: `<div title="Окончание">Окончание</div>`,
            align: 'center',
            // resize: true,
            min_width: 80,
            template: task => task.end_date
        },
        {
            name: 'duration',
            label: `<div title="Длительность">Длительность</div>`,
            align: 'center',
            width: 80,
            // resize: true,
            min_width: 100,
            template: task => task.duration
        },
        {
            name: 'value',
            label: `<div class="head_cell_doubleline" title="Объем [Итог]">
                        <div>Объем</div>
                        <div>[Итог]</div>
                    </div>`,
            align: 'center',
            // resize: true,
            width: 60,
            template: task => {
                let result = task.resource.factVolume;
                if (typeof task.resource.factVolume === 'number') {
                    result = task.resource.factVolume.toFixed(2);
                }

                return result;
            }
        },
        {
            name: 'unit',
            label: `<div class="head_cell_doubleline" title="Единица объема">
                        <div>Единица</div>
                        <div>объема</div>
                    </div>`,
            align: 'center',
            // resize: true,
            width: 60,
            template: task => task.resource.measureUnitShortName
        },
        {
            name: 'resCentHour',
            label: `<div class="head_cell_doubleline" title="Рабочие [Трудоемкость]">
                        <div>Рабочие</div>
                        <div>[Трудоемкость]</div>
                    </div>`,
            align: 'center',
            // resize: true,
            min_width: 100,
            template: task => {
                let result = task.resource.resCentHour;
                if (typeof task.resource.resCentHour === 'number') {
                    result = task.resource.resCentHour.toFixed(2);
                }

                return result;
            }
        },
        {
            name: 'workLoadSum',
            label: `<div class="head_cell_doubleline" title="Трудоемкость [Итог]">
                        <div>Трудоемкость</div>
                        <div>[Итог]</div>
                    </div>`,
            align: 'center',
            // resize: true,
            min_width: 100,
            template: task => {
                let result = task.resource.workLoadSum;
                if (typeof task.resource.workLoadSum === 'number') {
                    result = task.resource.workLoadSum.toFixed(2);
                }

                return result;
            }
        },
        {
            name: 'cSum1',
            label: `<div class="head_cell_doubleline" title="П.1.1 Доходы от реализации СМР [Итог]">
                        <div>П.1.1 Доходы от</div>
                        <div>реализации СМР [Итог]</div>
                    </div>`,
            align: 'center',
            // resize: true,
            min_width: 140,
            template: task => {
                let result = task.resource.cSum1;
                if (typeof task.resource.cSum1 === 'number') {
                    result = task.resource.cSum1.toFixed(2);
                }

                return result;
            }
        },
        {
            name: 'cSum111',
            label: `<div class="head_cell_doubleline" title="П.1.1.1 СМР собственные силы [Итог]">
                        <div>П.1.1.1 СМР собственные</div>
                        <div>силы [Итог]</div>
                    </div>`,
            align: 'center',
            // resize: true,
            min_width: 160,
            template: task => {
                let result = task.resource.cSum111;
                if (typeof task.resource.cSum111 === 'number') {
                    result = task.resource.cSum111.toFixed(2);
                }

                return result;
            }
        },
        {
            name: 'cSum112',
            label: `<div class="head_cell_doubleline" title="П.1.1.2 Субподряд [Итог]">
                        <div>П.1.1.2 Субподряд</div>
                        <div>[Итог]</div>
                    </div>`,
            align: 'center',
            // resize: true,
            min_width: 120,
            template: task => {
                let result = task.resource.cSum112;
                if (typeof task.resource.cSum112 === 'number') {
                    result = task.resource.cSum112.toFixed(2);
                }

                return result;
            }
        }
    ]
};

// Раздельный горизонтальный скролл
export const layout = {
    css: 'gantt_container',
    cols: [
        {
            rows: [
                { view: 'grid', scrollX: 'gridScroll', scrollable: true, scrollY: 'scrollVer' },
                { view: 'scrollbar', id: 'gridScroll', group: 'horizontal' }
            ]
        },
        { resizer: true, width: 1 },
        {
            rows: [
                {
                    cols: [
                        {
                            view: 'grid',
                            bind: 'task',
                            scrollX: 'gridScroll2',
                            scrollY: 'scrollVer',
                            scrollable: true,
                            config: resourceGridColumns
                        }
                    ]
                },
                { view: 'scrollbar', id: 'gridScroll2', group: 'horizontal' }
            ]
        },
        { resizer: true, width: 1 },
        {
            rows: [
                { view: 'timeline', scrollX: 'scrollHor', scrollY: 'scrollVer' },
                { view: 'scrollbar', id: 'scrollHor', group: 'horizontal' }
            ]
        },
        { view: 'scrollbar', id: 'scrollVer' }
    ]
};

export const columns = [{ name: 'text', label: 'Название', align: 'left', tree: true, width: 4000 }];
