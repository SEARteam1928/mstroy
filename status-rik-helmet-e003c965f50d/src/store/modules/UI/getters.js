export const drawerWidth = state => state.drawerWidth;
export const drawerLeft = state => state.drawerLeft;
export const miniState = state => state.miniState;
export const drawerBreakpoint = state => state.drawerBreakpoint;
export const drawerMobileMode = state => state.drawerMobileMode;

export const headerHeight = state => state.headerHeight;
export const isShowHeader = state => state.isShowHeader;

// Место размещения блока с выбором проектов
// На десктопе в портале LayoutHeaderProjects, а на телефоне в LeftMenuProjects
export const portalForHeaderProjectItem = state => {
    let { drawerMobileMode } = state;
    let portalName = 'LayoutHeaderProjects';
    if (drawerMobileMode) portalName = 'LeftMenuProjects';

    return portalName;
};
