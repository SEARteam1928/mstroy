import { ContextMenu } from './ContextMenu';

export default () => {
    return new ContextMenu({
        items: [
            [
                {
                    title: 'Очистить выделение',
                    getEnabled: function(context) {
                        return context.viewer.scene.numSelectedObjects > 0;
                    },
                    doAction: function(context) {
                        context.viewer.scene.setObjectsSelected(context.viewer.scene.selectedObjectIds, false);
                    }
                },
                {
                    title: 'Сфокусировать вид',
                    doAction: function(context) {
                        if(context.viewer.scene.numSelectedObjects > 0) {
                            const viewer = context.viewer;
                            const scene = viewer.scene;
                            const entity = context.entity;
                            viewer.cameraFlight.flyTo(
                                {
                                    aabb: entity.aabb,
                                    duration: 0.5
                                },
                                () => {
                                    setTimeout(function() {
                                        scene.setObjectsHighlighted(scene.highlightedObjectIds, false);
                                    }, 500);
                                }
                            );
                    } else {
                        
                            const scene = context.viewer.scene;
                            context.viewer.cameraFlight.flyTo({
                                projection: 'perspective',
                                aabb: scene.getAABB(),
                                duration: 0.5
                            });
                    }
                        console.log(context)
                    }
                }
            ],
            [
                {
                    title: 'Изолировать',
                    doAction: function(context) {
                        const viewer = context.viewer;
                        const scene = viewer.scene;
                        const entity = context.entity;
                        const metaObject = viewer.metaScene.metaObjects[entity.id];
                        if (!metaObject) {
                            return;
                        }
                        scene.setObjectsVisible(scene.objectIds, true);
                        scene.setObjectsXRayed(scene.objectIds, true);
                        scene.setObjectsHighlighted(scene.highlightedObjectIds, false);
                        
                        if(scene.selectedObjectIds.length > 0) {
                            scene.setObjectsXRayed(scene.selectedObjectIds, false);
                        } else {
                            // metaObject.withMetaObjectsInSubtree(metaObject => {
                            // const entity = scene.objects[metaObject.id];
                            // if (entity) {
                            //     entity.xrayed = false;
                            // }
                        // });
                    }
                        scene.setObjectsSelected(scene.selectedObjectIds, false);
                        
                        
                    }
                },
                {
                    title: 'Отменить изоляцию',
                    getEnabled: function(context) {
                        return context.viewer.scene.numXRayedObjects > 0;
                    },
                    doAction: function(context) {
                        context.viewer.scene.setObjectsXRayed(context.viewer.scene.xrayedObjectIds, false);
                    }
                }
            ],
            [
                {
                    title: 'Скрыть',
                    getEnabled: function(context) {
                        return context.entity.visible;
                    },
                    doAction: function(context) {
                        // context.entity.visible = false;
                        const viewer = context.viewer;
                        const scene = viewer.scene;
                        scene.setObjectsVisible(scene.selectedObjectIds, false);
                    }
                },
                {
                    title: 'Скрыть остальное',
                    doAction: function(context) {
                        const viewer = context.viewer;
                        const scene = viewer.scene;
                        const entity = context.entity;
                        const metaObject = viewer.metaScene.metaObjects[entity.id];
                        if (!metaObject) {
                            return;
                        }
                        scene.setObjectsVisible(scene.visibleObjectIds, false);
                        scene.setObjectsXRayed(scene.xrayedObjectIds, false);
                        scene.setObjectsVisible(scene.selectedObjectIds, true);
                        scene.setObjectsSelected(scene.selectedObjectIds, false);

                        scene.setObjectsHighlighted(scene.highlightedObjectIds, false);
                        metaObject.withMetaObjectsInSubtree(metaObject => {
                            const entity = scene.objects[metaObject.id];
                            if (entity) {
                                entity.visible = true;
                            }
                        });
                    }
                },
                // {
                //     title: 'Скрыть все',
                //     getEnabled: function(context) {
                //         return context.viewer.scene.numVisibleObjects > 0;
                //     },
                //     doAction: function(context) {
                //         context.viewer.scene.setObjectsVisible(context.viewer.scene.visibleObjectIds, false);
                //     }
                // },
                {
                    title: 'Показать все',
                    getEnabled: function(context) {
                        const scene = context.viewer.scene;
                        return scene.numVisibleObjects < scene.numObjects;
                    },
                    doAction: function(context) {
                        const scene = context.viewer.scene;
                        scene.setObjectsVisible(scene.objectIds, true);
                    }
                }
            ]
        ],
        enabled: true
    });
};
