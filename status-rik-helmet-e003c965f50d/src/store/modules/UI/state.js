export default {
    // Левое меню
    drawerWidth: 300,
    drawerLeft: false,
    miniState: true,
    drawerBreakpoint: 1024,
    drawerMobileMode: false,

    // Дефолтная высота шапки назначается в компоненте "LayoutHeader"
    headerHeight: 0,
    // Флаг для отображения шапки.
    // Он автоматически выставляется в соответствии со свойством isNotShowHeader из meta текущего роута.
    // Слежение за текущим роутом и смена этого флага происходит в компоненте "LayoutHeader"
    // Компоненты так же сами могут переключать этот флаг
    isShowHeader: true
};
