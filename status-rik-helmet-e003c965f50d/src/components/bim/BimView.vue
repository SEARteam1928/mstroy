<template>
    <div class="BimView" ref="BimView">
        <!-- <BimViewTree class="bimTreeContainer" ref="modelTree" :viewer="viewer" :bimModel="bimModel" /> -->
        <canvas
            class="bimCanvas"
            ref="bimCanvas"
            @mousedown="setMouseDownPos"
            @mouseup="setMouseUpPos"
            @mousemove="highlightObj"
        />
        <!-- <BimViewTreeWrapper :viewer="viewer" :bimModel="bimModel" :showModelTree="showModelTree" /> -->

        <BimProjectsWrapper :showProjectsTree="showProjectsTree" />
        <BimButtonsWrapper
            @toggle-fullscreen="toggleFullscreen"
            @toggle-navcube="toggleNavCube"
            @toggle-sectionplane="toggleSectionPlane"
        />
        <BimCubeViewer v-show="bimModel" :viewer="viewer" :activated="navCube" />
        <BimSectionPlaneViewer v-show="sectionPlane" :viewer="viewer" :visible="sectionPlane" />
        <BimSquareButtonsWrapper
            class="bim-square-btn-wrapper"
            @toggle-modeltree="toggleModelTree"
            @toggle-projectstree="toggleProjectsTree"
        />

        <DataPreloader
            id="BimViewSpinner"
            class="DataPreloader"
            :loading="true"
            loadingMessage="Загрузка модели"
            vertical
            ref="DataPreloader"
        />
    </div>
</template>

<script>
import { Viewer } from '@xeokit/xeokit-sdk/src/viewer/Viewer.js';
import { EmphasisMaterial } from '@xeokit/xeokit-sdk/src/viewer/scene/materials/EmphasisMaterial.js';
import canvasContextMenu from './canvasContextMenu';
import objectContextMenu from './objectContextMenu';
import { BIMServerLoaderPlugin } from './loader/BIMServerLoaderPlugin.js';
import BimViewTree from './BimViewTree.vue';
import BimButton from './BimButton.vue';
import BimButtonsWrapper from './BimButtonsWrapper.vue';
import BimCubeViewer from './BimCubeViewer.vue';
import BimSectionPlaneViewer from './BimSectionPlaneViewer.vue';
import BimSquareButtonsWrapper from './BimSquareButtonsWrapper.vue';
import BimViewTreeWrapper from './BimViewTreeWrapper.vue';
import BimProjectsWrapper from './BimProjectsWrapper.vue';

import DataPreloader from '../common/DataPreloader.vue';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'BimView',
    components: {
        BimViewTree,
        DataPreloader,
        BimButtonsWrapper,
        BimCubeViewer,
        BimSectionPlaneViewer,
        BimSquareButtonsWrapper,
        BimViewTreeWrapper,
        BimProjectsWrapper
    },
    props: {
        bimServerClient: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            viewer: null,
            cameraControl: null,
            bimServerLoader: null,
            bimModel: null,
            selectedEntity: null,
            viewerClickHandlerId: null,
            canvasContextMenu: null,
            objectContextMenu: null,
            navCube: false,
            sectionPlane: false,
            fullscreen: false,
            modelTree: false,
            projectsTree: false,
            mouseDownPos: null,
            deviation: 10
        };
    },
    computed: {
        ...mapGetters('Bim', ['selectedProject']),
        showNavCube() {
            return this.navCube && this.bimModel;
        },
        showModelTree() {
            // this.projectsTree = false;
            return this.modelTree && this.bimModel;
        },
        showProjectsTree() {
            // this.modelTree = false;
            return this.projectsTree;
        }
    },
    mounted() {
        // TODO: Убрать на проде
        window.BimView = this;

        this.canvasContextMenu = new canvasContextMenu();
        this.objectContextMenu = new objectContextMenu();

        this.init();
        this.loadProject();
        // this.canvasContextMenu = canvasContextMenu();
        // this.objectContextMenu = objectContextMenu();
        // this.initContextMenu(this.viewer);
    },
    beforeDestroy() {
        this.destroy();
    },
    watch: {
        selectedProject: {
            handler(newVal, prevVal) {
                this.destroy();

                if (!newVal) return;

                this.$nextTick(() => {
                    if (!this.init()) return;

                    this.loadProject(newVal);
                });
            },
            immediate: true
        }
    },
    methods: {
        ...mapMutations('Bim', [
            'setSelectedMetaObject',
            'clearSelectedMetaObject',
            'clearSelectedCompleteData',
            'setSelectedCompleteData'
        ]),
        onViewerClick(e) {
            // Если нажата левая кнопка мыши
            if (e.button === 0) {
                let hit = this.viewer.scene.pick({
                    canvasPos: [e.layerX, e.layerY]
                });
                // console.log(e);

                // Если сейчас произошел клик по объекту модели
                if (hit && hit.entity) {
                    let id = hit.entity.id;

                    let metaObject = { ...this.viewer.metaScene.metaObjects[id] };
                    let metaModelId = metaObject.metaModel.id;
                    metaObject.metaModel = { id: metaModelId };
                    delete metaObject.parent;

                    this.setSelectedMetaObject(metaObject);
                    this.clearSelectedCompleteData();
                    this.setSelectedCompleteData({
                        appId: metaObject.id
                    });

                    // Если есть ранее выбранный объект модели и сейчас произошел клик по нему же,
                    // снимаем с него визуальное выделение и очищаем selectedEntity
                    if (this.selectedEntity && this.selectedEntity.id === id) {
                        hit.entity.selected = false;
                        this.selectedEntity = null;
                        this.clearSelectedMetaObject();
                        this.clearSelectedCompleteData();

                        // Если есть ранее выбранный объект модели и сейчас произошел клик по другому объекту,
                        // снимаем с ранее выбранного визуальное выделение, выделяем и запоминаем новый объект
                    } else if (!e.ctrlKey && this.selectedEntity && this.selectedEntity.id !== id) {
                        // Очистка выделенных объектов
                        this.viewer.scene.setObjectsSelected(this.viewer.scene.selectedObjectIds, false);
                        hit.entity.selected = true;
                        this.selectedEntity = hit.entity;
                        console.info(this.viewer.scene);

                        // Если зажат ctrl, то не убирать выделение с предыдущих элементов
                    } else if (e.ctrlKey && this.selectedEntity && this.selectedEntity.id !== id) {
                        hit.entity.selected = true;
                        this.selectedEntity = hit.entity;
                    }
                    // Если не было ранее выбранного объекта модели, выделяем тот,
                    // по которому кликнули сейчас и запоминаем его
                    else {
                        hit.entity.selected = true;
                        this.selectedEntity = hit.entity;
                    }

                    // Если клик произошел за пределами модели
                } else {
                    // FIXME: Пока ничего не будем делать по клику вне модели, потому что сейчас
                    // не решена проблема случайных вызовов этого обработчика при прокрутки моделью мышкой,
                    // если сейчас здесь сделать сброс выбранного ранее объекта модели,
                    // то это будет сбрасывать всю открытую информацию по объекту
                }
            }
        },

        loadProject(selectedProject = this.selectedProject) {
            if (!selectedProject) return false;

            this.bimModel = null;

            let { name: id, schema, oid: poid, lastRevisionId: roid } = selectedProject;
            let bimModel = this.bimServerLoader.load({
                id, // Assigned to Node#id, and Node#isModel will also be set true
                schema,
                poid,
                roid,

                scale: [0.001, 0.001, 0.001], // Assigned to Node#scale, since model boundary exceeds view volume
                rotation: [-90, 0, 0], // Assigned to Node#rotation, since model "up" is +Z
                edges: true // Assigned to Node#edges, to emphasis edges
            });

            bimModel.on('loaded', () => {
                this.bimModel = bimModel;
                this.focusOnModel();
            });

            return true;
        },

        // Метод для восстановления прелоадера. Прелоадер удаляется автоматически при вызове метода destroy
        restorePreloader() {
            let BimViewContainer = this.$refs.BimView;
            let spinnerEl = BimViewContainer.querySelector('#BimViewSpinner');
            if (!spinnerEl) {
                let DataPreloaderEl = this.$refs.DataPreloader.$el;
                if (DataPreloaderEl) {
                    BimViewContainer.appendChild(DataPreloaderEl);
                }
            }
        },
        init() {
            //------------------------------------------------------------------------------------------------------------------
            // Create a Viewer,
            // position the camera and
            // tweak the default xraying and highlighting materials
            //------------------------------------------------------------------------------------------------------------------

            if (!this.$refs.bimCanvas) return false;

            this.restorePreloader();

            const viewer = new Viewer({
                canvasElement: this.$refs.bimCanvas,
                transparent: true,

                // Кастомный прелоадер нужен для того, чтобы все прелоадеры в приложении были в одном стиле
                // + родной прелоадер имеет z-index: 9000 и отображается поверх меню выбора проектов из шапки, если его открыть пока активен прелоадер
                spinnerElementId: 'BimViewSpinner'
            });

            viewer.camera.eye = [-3.06, 8.19, 11.253];
            viewer.camera.look = [6.22, 5.84, -2.1];
            viewer.camera.up = [0.08, 0.98, -0.11];

            viewer.scene.xrayMaterial.fillAlpha = 0.1;
            viewer.scene.xrayMaterial.fillColor = [0, 0, 0];
            viewer.scene.xrayMaterial.edgeAlpha = 0.4;
            viewer.scene.xrayMaterial.edgeColor = [0, 0, 0];

            viewer.scene.highlightMaterial.fillAlpha = 0.3;
            viewer.scene.highlightMaterial.edgeColor = [1, 1, 0];

            this.viewer = viewer;

            this.bimServerLoader = new BIMServerLoaderPlugin(this.viewer, {
                bimServerClient: this.bimServerClient
            });

            // Материал для выделения
            let highlightMaterial = viewer.scene.highlightMaterial;
            // Цвет заливки
            highlightMaterial.fillColor = [0.3, 0.3, 0.3];
            // Цвет граней
            highlightMaterial.edgeColor = [0.3, 0.3, 0.4];
            // Прозрачность заливки
            highlightMaterial.fillAlpha = 0.6;

            this.initContextMenu();
            this.cameraControl = this.viewer.cameraControl;
            this.cameraControl.panRightClick = false;

            return true;
        },
        initContextMenu(viewer = this.viewer) {
            this.$refs.bimCanvas.oncontextmenu = e => {
                e.preventDefault();
                e.stopPropagation();

                // Right-clicked on the canvas
                // console.log('Right Click');
                if (!this.objectContextMenu.enabled) {
                    return;
                }

                let hit = viewer?.scene?.pick?.({
                    // Try to pick an Entity at the coordinates
                    canvasPos: [e.layerX, e.layerY]
                });
                // console.log(viewer.scene);
                if (hit && this.viewer.scene.selectedObjectIds.length > 0) {
                    // Picked an Entity
                    this.objectContextMenu.context = {
                        // Feed entity to ContextMenu
                        viewer,
                        entity: hit.entity
                    };
                    this.objectContextMenu.show(e.layerX, e.layerY); // Show the ContextMenu
                } else {
                    this.canvasContextMenu.context = { viewer };
                    this.canvasContextMenu.show(e.layerX, e.layerY);
                }
            };
        },
        destroy() {
            if (!this.viewer) return;

            this.bimServerLoader = null;
            this.bimModel = null;
            this.selectedEntity = null;
            this.clearSelectedMetaObject();

            this.viewer.scene.input.off(this.viewerClickHandlerId);
            this.viewerClickHandlerId = null;

            this.viewer.destroy();
            this.viewer = null;
        },
        focusOnModel() {
            if (!this.viewer) return;
            const scene = this.viewer.scene;
            this.viewer.cameraFlight.flyTo({
                projection: 'perspective',
                aabb: scene.getAABB(),
                duration: 0.5
            });
        },
        toggleFullscreen() {
            this.fullscreen ? document.exitFullscreen() : this.$refs.BimView.requestFullscreen();
            this.fullscreen = !this.fullscreen;
        },
        toggleNavCube() {
            this.navCube = !this.navCube;
        },
        toggleSectionPlane() {
            this.sectionPlane = !this.sectionPlane;
        },
        toggleModelTree() {
            this.modelTree = !this.modelTree;
        },
        toggleProjectsTree() {
            this.projectsTree = !this.projectsTree;
        },
        // Установка координат мыши в нажатом положении
        setMouseDownPos(e) {
            let x = e.layerX;
            let y = e.layerY;
            this.mouseDownPos = { x, y };
        },
        // Установка координат мыши в отпущеном положении
        setMouseUpPos(e) {
            let down = this.mouseDownPos;

            let up = { x: e.layerX, y: e.layerY };

            // Если координаты совпадают, то вызывается обработчик клика
            if (this.checkDeviation(up.x, down.x) && this.checkDeviation(up.y, down.y)) {
                this.onViewerClick(e);
            }
        },
        // Проверка координат на совпадение (погрешность включена)
        checkDeviation(up, down) {
            return Math.abs(up - down) <= this.deviation;
        },
        highlightObj(e) {
            let hit = this.viewer.scene.pick({
                canvasPos: [e.layerX, e.layerY]
            });
            this.viewer.scene.setObjectsHighlighted(this.viewer.scene.objectIds, false);
            if (hit && !hit.entity.selected) {
                hit.entity.highlighted = true;
            }
        }
    }
};
</script>

<style lang="sass">
.BimView
    position: relative
    overflow: hidden
    width: 100%
    height: 100%
    background-color: #fff
    border-radius: 4px
    .bimTreeContainer
        border-radius: 0px
    canvas
        width: 100%
        height: 100%
    .DataPreloader
        transform: none
</style>

<style lang="sass">
.hide-context-item
    display: none !important
.xeokit-context-menu
    box-shadow: 0 2px 10px 0 rgba(0,0,0,.12)
    font-weight: 350
    font-size: 12px
    z-index: 2147483648
    ul
        list-style: none
        padding: 0
        width: 200px
        li
            cursor: pointer
            padding: 9px 12px
            border-color: #e4e4e4
        li:hover
            background: var(--q-color-custom-icon-bg)
.context-border
    border-bottom: 1px solid #e4e4e4 !important

.xeokit-non-bordered
    display: none
.xeokit-context-block-separator
    height: 1px
    padding: 0
    margin: 0
    border-bottom: 1px solid #e4e4e4
</style>
