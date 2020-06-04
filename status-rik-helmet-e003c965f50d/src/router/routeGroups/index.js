// Позволяет импортировать группы роутов, которые вынесены по отдельным файлам,
// предварительно заполнив в каждом роуте метаинформацию о соседних роутах его группы.
// Нужно для организации табов со ссылками на страницы группы.
import { groupImporter, injectMetaGroup } from './groupImporter';

import home from './home';
import engineering from './engineering';
import personnel from './personnel';
import management from './management';
import control from './control';
import filemanager from './filemanager';
import settings from './settings';

import other from './other';

// Все роуты одним массивом, без групп
const routes = [
    ...home,
    ...engineering,
    ...personnel,
    ...management,
    ...control,
    ...filemanager,
    ...settings,
    ...other
];

// Если роуты в свойстве routes, то это добавит раскрывающуюся группу в меню,
// а если в свойстве route, то добавит отдельный пункт без группы
// Переименовывать раскрывающиеся секции групп страниц нужно будет здесь.
// Ключ объекта - отображаемое имя в меню
const groups = {
    'Проектирование': {
        routes: injectMetaGroup(engineering),
        icon: 'pencil-ruler'
    },
    'Персонал': {
        routes: injectMetaGroup(personnel),
        icon: 'icon-users'
    },
    'Управление строительством': {
        routes: injectMetaGroup(management),
        icon: 'sliders-h-square'
    },
    'Строительный контроль': {
        routes: injectMetaGroup(control),
        icon: 'check-square'
    },
    'Файловое хранилище': {
        route: injectMetaGroup(filemanager),
        icon: 'folder'
    },
    'Настройки': {
        routes: injectMetaGroup(settings),
        icon: 'cog'
    }
};

// Массив ключей групп роутов
const groupsKeys = Object.keys(groups);

export default groups;
export { injectMetaGroup, groupImporter, routes, groups, groupsKeys };
