import routeGuardBuilder from './routeGuardBuilder';
export default routeGuardBuilder;

import User from '@services/user';

// Если юзер не авторизован, никуда не пускаем и редиректим на страницу логина
export const noAuthGuard = (to, from, next, store) => {
    let redirect;

    if (!User.isAuthorized && to.name !== 'login') {
        redirect = { name: 'login' };
    }

    next(redirect);
};

// Если юзер авторизован, и пытается зайти на страницу логина, то редиректим его на главную
export const authGuard = (to, from, next, store) => {
    let redirect;

    if (User.isAuthorized && to.name === 'login') {
        redirect = { name: 'home' };
    }

    // TODO: Временная заглушка для того, чтобы сразу открывалась не главная, а WorkPerformance
    // if (to.name === 'home' || (redirect && redirect.name === 'home')) {
    //     redirect = {
    //         name: 'workPerformance'
    //     };
    // }

    next(redirect);
};

// Если у роута "to" определен сценарий, проверяем, разрешен ли этот сценарий у пользователя,
// если не разрешен, редиректим на страницу-заглушку "error403"
export const scenarioGuard = (to, from, next, store) => {
    let redirect;

    if (to.meta && to.meta.scenarios && !User.checkScenarios(to.meta.scenarios[0].name)) {
        redirect = { name: 'error403' };
    }

    next(redirect);
};
