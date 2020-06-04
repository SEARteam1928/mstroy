import { scroll, throttle as Throttle } from 'quasar';
const { getScrollbarWidth } = scroll;

export default class ComputeRowHeight {
    constructor({ container, observer, minRowHeight, maxRowHeight, throttle }) {
        this.container = container;
        this.observer = observer;
        this.minRowHeight = minRowHeight;
        this.maxRowHeight = maxRowHeight;

        this.autoHeightClassFlag = 'table-auto-row-height';
        this.defaultValue = 'inherit';
        this.rowHeight = this.defaultValue;

        // Если указано значение троттлинга
        if (typeof throttle === 'number') {
            this.compute = Throttle(this.compute, throttle);
        }

        // Если передан компонент обзервера, подписываемся на изменение размеров
        if (this.observer && this.observer.$on) {
            this.observer.$on('resize', this.compute);
        }

        // После инициализации принудительно первый раз запускаем расчет
        this.compute();

        // Из конструктора возвращаем только метод расчета для его принудительного вызова из компонента
        return this.compute;
    }

    _updateRowHeight() {
        this.container.classList.add(this.autoHeightClassFlag);
        this.container.style.setProperty('--row-height', this.rowHeight);
    }

    findRowHeight(tableTop, tableHeader, rowsAmount) {
        // Общая высота, которую занимает блок-обертка таблицы
        let containerHeight = this.container.offsetHeight;
        let containerWidth = this.container.offsetWidth;

        // Высота верхнего слота таблицы(заголовка)
        let tableTopHeight = tableTop.offsetHeight;

        // Размеры строки заголовков столбцов
        let tableHeaderHeight = tableHeader.offsetHeight;
        let tableHeaderWidth = tableHeader.offsetWidth;

        // Максимальная высота, которая остается на тело таблицы
        let maxBodyHeight = containerHeight - tableTopHeight - tableHeaderHeight - 1;

        // Если ширина контейнера меньше ширины таблицы, внизу есть горизонтальный скролл
        // и его надо вычесть из высоты, доступной для тела таблицы
        if (containerWidth < tableHeaderWidth + 2) {
            // Размер скроллбара
            let scrollBarWidth = getScrollbarWidth();
            maxBodyHeight -= scrollBarWidth;
        }

        // Рассчитанная высота одной строки
        let rowHeight = Math.floor(maxBodyHeight / rowsAmount) - 1;

        // Если рассчитанная высота получилась меньше минимальной,
        // то зададим строкам минимальную высоту - 1px на бордер строки
        if (rowHeight < this.minRowHeight) {
            rowHeight = this.minRowHeight - 1;
        }

        // Если рассчитанная высота получилась больше максимальной,
        // то зададим строкам максимальную высоту - 1px на бордер строки
        if (rowHeight > this.maxRowHeight) {
            rowHeight = this.maxRowHeight - 1;
        }

        // // Если осталось свободное место, то добавим его к высоте строки заголовков столбцов
        // let restSpace = maxBodyHeight - (rowHeight + 1) * rowsAmount;
        // if (restSpace) {
        //     tableHeader.style.height = `${tableHeaderHeight + restSpace}px`;
        // }

        return rowHeight;
    }

    compute = () => {
        if (!this.container) {
            this.rowHeight = this.defaultValue;
            this._updateRowHeight();

            return this.rowHeight;
        }

        // Верхний слот таблицы(заголовка)
        let tableTop = this.container.querySelector('.q-table__top');

        // Строка заголовков столбцов
        let tableHeader = this.container.querySelector('thead tr');
        tableHeader.style.height = '';

        // Количество строк
        let rowsAmount = this.container.querySelectorAll('tbody tr').length;
        if (!rowsAmount) {
            this.rowHeight = this.defaultValue;
            this._updateRowHeight();

            return this.rowHeight;
        }

        let rowHeight = this.findRowHeight(tableTop, tableHeader, rowsAmount);
        let tableHeaderHeight = tableHeader.offsetHeight;

        // Если высота строки получилась больше высоты строки заголовков столбцов,
        // строке заголовков зададим полученную высоту строк, а затем снова пересчитаем высоту строк
        // с учетом новой высоты строки заголовков (обычные строки при этом должны получаться чуть меньше по высоте)
        if (rowHeight > tableHeaderHeight) {
            tableHeader.style.height = `${rowHeight + 1}px`;
            rowHeight = this.findRowHeight(tableTop, tableHeader, rowsAmount);
        }

        this.rowHeight = `${rowHeight}px`;

        this._updateRowHeight();

        return this.rowHeight;
    };
}
