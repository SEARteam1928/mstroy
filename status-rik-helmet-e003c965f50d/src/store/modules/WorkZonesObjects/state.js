export default {
    projectId: null,

    // Название рабочей зоны, которая отображает общую рабочую зону проекта,
    // при выводе объектов на карту будет отправляться на самый нижний слой
    constructionSiteName: 'Строительная площадка',

    objects: [],
    objectsCoords: [],

    // Отображаемые объекты
    // Number - показать определенный объект по его object_id,
    // Array Number - показать несколько объектов по их object_id
    // Если массив пустой - показываются все объекты
    show: [],

    // Выделенные объекты
    // Number - выделить определенный объект по его object_id,
    // Array Number - выделить несколько объектов по их object_id
    // Если массив пустой - не выделяется ни один объект
    highlight: [],

    popups: false,
    tooltips: false,

    moduleErrors: {
        requestObjects: false,
        requestObjectsCoords: false
    }
};
