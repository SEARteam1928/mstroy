<template>
    <div class="LeftMenu">
        <q-drawer
            class="drawer"
            v-model="drawerLeftModel"
            show-if-above
            :width="drawerWidth"
            :mini="miniState"
            :breakpoint="drawerBreakpoint"
            content-class="column"
        >
            <q-list class="column full-height drawer-q-list">
                <!-- Верхняя секция меню, которая не прокручивается -->
                <div class="drawer-top-menu-group">
                    <!-- Пункт меню, ведущий на главную страницу -->
                    <DrawerMenuItem
                        class="drawer-menu-item drawer-menu-item-main"
                        label="MStroy"
                        exact
                        bold
                        icon
                        :to="{ name: 'home' }"
                    >
                        <template v-slot:icon>
                            <!-- Кнопка переключения меню в компактный режим -->
                            <q-btn
                                class="drawerMiniToggle"
                                flat
                                dense
                                round
                                @click="drawerClick"
                                aria-label="Menu"
                                icon="menu"
                            />
                        </template>
                    </DrawerMenuItem>

                    <PortalTarget class="LeftMenu-PortalTargetProjects" name="LeftMenuProjects"></PortalTarget>
                    <q-separator :inset="!miniState" />
                </div>

                <q-scroll-area
                    class="drawer-scroll-section"
                    :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }"
                >
                    <!-- Цикл по группам роутов для вывода пунктов соответствующих в меню -->
                    <!-- Пункты меню берутся из объекта groups в файле src/router/routeGroups -->
                    <LeftMenuRouteItem
                        v-for="(routeGroup, routeGroupName) in routeGroups"
                        :key="routeGroupName"
                        :routeGroup="routeGroup.routes"
                        :route="routeGroup.route"
                        :routeGroupName="routeGroupName"
                        :icon="routeGroup.icon"
                        :tooltip="showTooltips"
                    />
                </q-scroll-area>

                <!-- Сдвигает вниз до упора -->
                <q-space class="col" />

                <!-- Нижняя секция меню, которая не прокручивается -->
                <div class="drawer-bottom-menu-group">
                    <q-separator :inset="!miniState" />
                    <UserItem />
                </div>
            </q-list>
        </q-drawer>
    </div>
</template>

<script>
import LeftMenuRouteItem from './LeftMenuRouteItem.vue';
import DrawerMenuItem from './DrawerMenuItem.vue';
import UserItem from './UserItem.vue';

import routeGroups from '@router/routeGroups';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'LeftMenu',
    components: {
        LeftMenuRouteItem,
        DrawerMenuItem,
        UserItem
    },
    data() {
        return {
            routeGroups
        };
    },
    computed: {
        ...mapGetters('UI', ['drawerWidth', 'drawerLeft', 'miniState', 'drawerBreakpoint', 'drawerMobileMode']),

        drawerLeftModel: {
            get() {
                return this.drawerLeft;
            },
            set(val) {
                this.setDrawerLeft(val);
            }
        },

        showTooltips() {
            return this.miniState;
        },

        mobileMode() {
            return this.$q.screen.width < this.drawerBreakpoint;
        }
    },
    watch: {
        mobileMode: {
            handler(newMobileMode) {
                this.setDrawerMobileMode(newMobileMode);
            },
            immediate: true
        }
    },
    methods: {
        ...mapMutations('UI', ['setDrawerLeft', 'setMiniState', 'setDrawerMobileMode']),

        drawerClick(e) {
            e.stopPropagation();
            e.preventDefault();

            let { width } = this.$q.screen;

            // До брейкпоинта, на котором прячется левое меню, переводим его в компактный режим и обратно
            if (width > this.drawerBreakpoint) {
                this.setMiniState(!this.miniState);

                // Если экран меньше брейкпоинта, то скрываем/показываем меню полностью
            } else {
                this.setDrawerLeft(!this.drawerLeftModel);
            }
        }
    }
};
</script>

<style lang="sass">
.LeftMenu
    .drawer
        &-q-list
            flex-wrap: nowrap
        &-scroll-section
            flex-grow: 1
            height: 100%
            .q-scrollarea__thumb
                background: #3DA0D1
                opacity: 1
        &-menu
            &-expansion
                font-size: 14px
                &.expansion-level-2
                    margin-left: 30px

                // Состояние когда заголовок группы пунктов выступает в качестве ссылки и сейчас на ее странице
                .q-router-link--active
                    color: #fff
                    background: rgba(0, 0, 0, 0.15)
                    border-color: #fff
                    position: relative;
                    &:before
                        content: ''
                        position: absolute
                        top: 0
                        bottom: 0
                        left: 0
                        border-left: 3px solid #fff
                        -webkit-border-radius: inherit
                        border-radius: inherit
                        z-index: 0
            &-item
                font-size: 14px
                &-main
                    font-size: 16px

        .drawer-menu-item
            display: flex
            align-items: center
            position: relative
            &.drawer-menu-item-main
                font-size: 20px
                height: var(--header-height)
                .drawerMiniToggle
                    z-index: 10
                    &:after
                        content: ''
                        position: absolute
                        left: -16px
                        right: -4px
                        top: -12px
                        bottom: -12px
                        z-index: 0
                    .q-focus-helper
                        z-index: 5
                    .q-btn__content
                        z-index: 10

        .q-expansion-item
            color: #fff
            .q-expansion-item__toggle-icon
                color: #fff
            .q-expansion-item__container > .q-item
                min-height: 40px
                padding: 4px 12px
                .q-item__section--avatar
                    width: 32px
                    min-width: 32px
                    height: 32px
                    padding-right: 0
                    align-items: center
            .q-item__section--main
                padding-left: 6px

                // Раскрытая секция
            &.q-expansion-item--expanded
                .q-item__section
                    font-weight: bold
                .drawer-menu-item
                    .q-item__section
                        font-weight: normal

        .q-drawer
            background: linear-gradient(160.12deg, #3DA0D1 0%, rgba(255, 255, 255, 0) 100%), #525D9C;

        .q-separator
            background: rgba(255, 255, 255 ,0.2)

        // Компактный режим меню
        .q-drawer--mini
            .drawer-menu-item
                &.drawer-menu-item-main
                    .drawerMiniToggle
                        &:after
                            left: -16px
                            right: -16px
                            top: -16px
                            bottom: -16px
            .q-expansion-item
                &.q-expansion-item--expanded
                    .q-item__section
                        align-items: center
                        padding: 0
            .q-separator
                background: rgba(0,0,0,0.12)

    &-PortalTargetProjects
        z-index: 10
        .HeaderProjectItem
            height: 44px
            *
                color: var(--ms-dark) !important
            &-wrap
                z-index: 10
            &-expansion
                border-radius: 0

            &-title
                font-size: 12px
                line-height: 18px

            .HeaderProjectSelector
                height: 70vh

            .HeaderProjectSelectorProjectsList
                &-section
                    padding-top: 8px
                    padding-bottom: 8px
                    padding-left: 4px
                &-radio
                    width: calc(100% - 4px)
                    margin-right: 4px
</style>
