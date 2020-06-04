<template>
    <div class="Gantt" ref="gantt"></div>
</template>

<script>
import scaleConfigs from './scaleConfigs';
import { columns, layout } from './layout';

import './codebase/dhtmlxgantt';
import './codebase/locale/locale_ru';
import './codebase/dhtmlxgantt.css';

// Расширения
// import './codebase/ext/dhtmlxgantt_quick_info'; // Информация о задаче в попапе при выборе задачи
// import './codebase/ext/dhtmlxgantt_tooltip'; // Информация о задаче в тултипе при наведении на задачу
import './codebase/ext/dhtmlxgantt_drag_timeline'; // Перетаскивание за пустое место правой части(зона таймлайна)
import './codebase/ext/dhtmlxgantt_keyboard_navigation'; // Навигация с клавиатуры
import './codebase/ext/dhtmlxgantt_marker'; // Позволяет добавлять маркеры дат на таймлайне

export default {
    name: 'Gantt',
    props: {
        tasks: {
            type: Object,
            default() {
                return { data: [], links: [] };
            }
        }
    },
    data() {
        return {
            todayMarkerId: null,
            todayMarkerInterval: null
        };
    },
    created() {
        window.Gantt = this;
    },
    methods: {
        zoomToFit() {
            let project = gantt.getSubtaskDates(),
                areaWidth = gantt.$task.offsetWidth;

            for (var i = 0; i < scaleConfigs.length; i++) {
                let columnCount = this.getUnitsBetween(
                    project.start_date,
                    project.end_date,
                    scaleConfigs[i].scales[0].subscale_unit,
                    scaleConfigs[i].scales[0].step
                );
                if ((columnCount + 2) * gantt.config.min_column_width >= areaWidth) {
                    --i;
                    break;
                }
            }

            if (i == scaleConfigs.length) {
                i--;
            }

            this.applyConfig(scaleConfigs[i], project);

            this.$emit('zoomLevel', i);
            this.$emit('zoomConfig', scaleConfigs[i]);
        },
        applyConfig(config, dates) {
            gantt.config.scales = config.scales;

            if (dates && dates.start_date && dates.end_date) {
                gantt.config.start_date = gantt.date.add(dates.start_date, -1, config.scales[0].subscale_unit);
                gantt.config.end_date = gantt.date.add(
                    gantt.date[config.scales[0].subscale_unit + '_start'](dates.end_date),
                    2,
                    config.scales[0].subscale_unit
                );
            } else {
                gantt.config.start_date = gantt.config.end_date = null;
            }

            gantt.render();
        },
        getUnitsBetween(from, to, unit, step) {
            let start = new Date(from),
                end = new Date(to);
            let units = 0;
            while (start.valueOf() < end.valueOf()) {
                units++;
                start = gantt.date.add(start, step, unit);
            }
            return units;
        },
        $_initGanttEvents() {
            if (gantt.$_eventsInitialized) return;
            gantt.attachEvent('onTaskSelected', id => {
                let task = gantt.getTask(id);
                this.$emit('task-selected', task);
            });

            gantt.attachEvent('onAfterTaskAdd', (id, task) => {
                this.$emit('task-updated', id, 'inserted', task);
                task.progress = task.progress || 0;
                if (gantt.getSelectedId() == id) {
                    this.$emit('task-selected', task);
                }
            });

            gantt.attachEvent('onAfterTaskUpdate', (id, task) => {
                this.$emit('task-updated', id, 'updated', task);
            });

            gantt.attachEvent('onAfterTaskDelete', id => {
                this.$emit('task-updated', id, 'deleted');
                if (!gantt.getSelectedId()) {
                    this.$emit('task-selected', null);
                }
            });

            gantt.attachEvent('onAfterLinkAdd', (id, link) => {
                this.$emit('link-updated', id, 'inserted', link);
            });

            gantt.attachEvent('onAfterLinkUpdate', (id, link) => {
                this.$emit('link-updated', id, 'updated', link);
            });

            gantt.attachEvent('onAfterLinkDelete', (id, link) => {
                this.$emit('link-updated', id, 'deleted');
            });

            // Нужно для расчета масштаба таймлайна, чтобы после инициализации отобразить весь проект
            gantt.attachEvent('onGanttReady', () => {
                this.$nextTick(() => {
                    this.zoomToFit();
                });
            });

            gantt.$_eventsInitialized = true;
        }
    },

    mounted() {
        this.$_initGanttEvents();

        gantt.config.add_column = false;

        // Высота шапки
        gantt.config.scale_height = 32;

        // Высота строк
        gantt.config.row_height = 22;

        // Формат дат в левой панели с задачами
        gantt.config.date_grid = '%d.%m.%Y';

        gantt.config.min_column_width = 90;

        gantt.config.scales = [{ unit: 'month', step: 1, format: '%M %Y' }];

        // Добавляет маркер с сегодняшней датой на таймлайн
        let date_to_str = gantt.date.date_to_str(gantt.config.task_date);
        let today = new Date();
        this.todayMarkerId = gantt.addMarker({
            start_date: today,
            css: 'today',
            text: 'Сегодня',
            title: 'Сегодня: ' + date_to_str(today)
        });

        // Передвигает раз в минуту на актуальное время маркер с сегодняшней датой
        this.todayMarkerInterval = setInterval(() => {
            let todayMarker = gantt.getMarker(this.todayMarkerId);
            todayMarker.start_date = new Date();
            todayMarker.title = 'Сегодня: ' + date_to_str(todayMarker.start_date);
            gantt.updateMarker(this.todayMarkerId);
        }, 1000 * 60);

        // Конфигурация лейоута
        gantt.config.columns = columns;
        gantt.config.layout = layout;

        // Определение строк, которые нужно подсветить
        // Классы на строках таблицы слева
        gantt.templates.grid_row_class = (start_date, end_date, item) => {
            let classes = [];
            if (item.isResource) classes.push('isResource');

            // Вешает класс на строки, содержащие дочерние элементы. На этот класс вешается жирный шрифт
            if (gantt.hasChild(item.id)) classes.push('gantt_row_task_parent');

            return classes.join(' ');
        };

        // Классы на строках таймлайна
        gantt.templates.task_row_class = (start_date, end_date, item) => {
            let classes = [];
            if (item.isResource) classes.push('isResource');

            // Вешает класс на строки, содержащие дочерние элементы. На этот класс вешается жирный шрифт
            if (gantt.hasChild(item.id)) classes.push('gantt_row_task_parent');

            return classes.join(' ');
        };

        gantt.init(this.$refs.gantt);
        gantt.parse(this.$props.tasks);
    },
    beforeDestroy() {
        clearInterval(this.todayMarkerInterval);
    }
};
</script>

<style lang="sass">
.Gantt
    .gantt_row.gantt_row_task_parent
        font-weight: bold

    .gantt_marker
        &.today
            background-color: #ff2753

    .gantt_row.isResource
        background-color: #DFFFFE
        &:hover
            background-color: #fff3a1
        &.gantt_selected
            background-color: #bbedeb
            &:hover
                background-color: #b3f1ee

    .gantt_task_row.isResource
        background-color: #DFFFFE
        &.gantt_selected
            background-color: #bbedeb
            &:hover
                background-color: #b3f1ee

    .gantt_grid_head_cell
        // Выравнивает заголовок столбца с названиями задач по левому краю
        &[role="columnheader"][data-column-id="text"]
            text-align: left
            padding: 0 30px
        // Регулирует высоту строк для заголовков из двух строк
        .head_cell_doubleline
            line-height: calc((100% / 2) + 75%);

        // У кастомной таблицы разделители в заголовках
        &.gantt_grid_head
            &_start_date,
            &_end_date,
            &_duration,
            &_value,
            &_unit,
            &_resCentHour,
            &_workLoadSum,
            &_cSum1,
            &_cSum111,
            &_cSum112,
                display: inline-flex
                justify-content: center
                align-items: center
                padding: 0 2px
                border-right: 1px solid #ebebeb !important

    .gantt_grid_data
        .gantt_cell:not(.gantt_last_cell)
            border-right: 1px solid #ebebeb
</style>
