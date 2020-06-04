import { ContextMenu } from './ContextMenu';

export default () => {
    return new ContextMenu({
        items: [
            [
                {
                    title: 'Сфокусироваться на элементе',
                    doAction: function(context) {
                        const scene = context.viewer.scene;
                        const objectIds = [];
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                objectIds.push(treeViewNode.objectId);
                            }
                        });
                        scene.setObjectsVisible(objectIds, true);
                        scene.setObjectsHighlighted(objectIds, true);
                        context.viewer.cameraFlight.flyTo(
                            {
                                projection: 'perspective',
                                aabb: scene.getAABB(objectIds),
                                duration: 0.5
                            },
                            () => {
                                setTimeout(function() {
                                    scene.setObjectsHighlighted(scene.highlightedObjectIds, false);
                                }, 500);
                            }
                        );
                    }
                },
                {
                    title: 'Сфокусироваться на модели',
                    doAction: function(context) {
                        const scene = context.viewer.scene;
                        context.viewer.cameraFlight.flyTo({
                            projection: 'perspective',
                            aabb: scene.getAABB({}),
                            duration: 0.5
                        });
                    }
                }
            ],
            [
                {
                    title: 'Скрыть элемент',
                    doAction: function(context) {
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                const entity = context.viewer.scene.objects[treeViewNode.objectId];
                                if (entity) {
                                    entity.visible = false;
                                }
                            }
                        });
                    }
                },
                {
                    title: 'Изолировать элемент',
                    doAction: function(context) {
                        const scene = context.viewer.scene;
                        scene.setObjectsVisible(scene.visibleObjectIds, false);
                        scene.setObjectsXRayed(scene.xrayedObjectIds, false);
                        scene.setObjectsSelected(scene.selectedObjectIds, false);
                        scene.setObjectsHighlighted(scene.highlightedObjectIds, false);
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                const entity = scene.objects[treeViewNode.objectId];
                                if (entity) {
                                    entity.visible = true;
                                }
                            }
                        });
                    }
                },
                {
                    title: 'Скрыть все',
                    getEnabled: function(context) {
                        return context.viewer.scene.visibleObjectIds.length > 0;
                    },
                    doAction: function(context) {
                        context.viewer.scene.setObjectsVisible(context.viewer.scene.visibleObjectIds, false);
                    }
                }
            ],
            [
                {
                    title: 'Показать элемент',
                    doAction: function(context) {
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                const entity = context.viewer.scene.objects[treeViewNode.objectId];
                                if (entity) {
                                    entity.visible = true;
                                    entity.xrayed = false;
                                    entity.selected = false;
                                }
                            }
                        });
                    }
                },
                {
                    title: 'Показать остальное',
                    doAction: function(context) {
                        const scene = context.viewer.scene;
                        scene.setObjectsVisible(scene.objectIds, true);
                        scene.setObjectsXRayed(scene.xrayedObjectIds, false);
                        scene.setObjectsSelected(scene.selectedObjectIds, false);
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                const entity = scene.objects[treeViewNode.objectId];
                                if (entity) {
                                    entity.visible = false;
                                }
                            }
                        });
                    }
                },
                {
                    title: 'Показать все',
                    getEnabled: function(context) {
                        const scene = context.viewer.scene;
                        return scene.numVisibleObjects < scene.numObjects;
                    },
                    doAction: function(context) {
                        const scene = context.viewer.scene;
                        scene.setObjectsVisible(scene.objectIds, true);
                        scene.setObjectsXRayed(scene.xrayedObjectIds, false);
                        scene.setObjectsSelected(scene.selectedObjectIds, false);
                    }
                }
            ],
            [
                {
                    title: 'X-Ray',
                    doAction: function(context) {
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                const entity = context.viewer.scene.objects[treeViewNode.objectId];
                                if (entity) {
                                    entity.xrayed = true;
                                    entity.visible = true;
                                }
                            }
                        });
                    }
                },
                {
                    title: 'Отменить X-Ray',
                    doAction: function(context) {
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                const entity = context.viewer.scene.objects[treeViewNode.objectId];
                                if (entity) {
                                    entity.xrayed = false;
                                }
                            }
                        });
                    }
                },
                {
                    title: 'X-Ray на остальном',
                    doAction: function(context) {
                        const scene = context.viewer.scene;
                        scene.setObjectsVisible(scene.objectIds, true);
                        scene.setObjectsXRayed(scene.objectIds, true);
                        scene.setObjectsSelected(scene.selectedObjectIds, false);
                        scene.setObjectsHighlighted(scene.highlightedObjectIds, false);
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                const entity = scene.objects[treeViewNode.objectId];
                                if (entity) {
                                    entity.xrayed = false;
                                }
                            }
                        });
                    }
                },
                {
                    title: 'Отменить X-Ray',
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
                    title: 'Выделить',
                    doAction: function(context) {
                        context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                            if (treeViewNode.objectId) {
                                const entity = context.viewer.scene.objects[treeViewNode.objectId];
                                if (entity) {
                                    entity.selected = true;
                                    entity.visible = true;
                                }
                            }
                        });
                    }
                },
                // {
                //     title: 'Отмена выделения',
                //     doAction: function(context) {
                //         context.treeViewPlugin.withNodeTree(context.treeViewNode, treeViewNode => {
                //             if (treeViewNode.objectId) {
                //                 const entity = context.viewer.scene.objects[treeViewNode.objectId];
                //                 if (entity) {
                //                     entity.selected = false;
                //                 }
                //             }
                //         });
                //     }
                // },
                // {
                //     title: 'Убрать выделение',
                //     getEnabled: function(context) {
                //         return context.viewer.scene.numSelectedObjects > 0;
                //     },
                //     doAction: function(context) {
                //         context.viewer.scene.setObjectsSelected(context.viewer.scene.selectedObjectIds, false);
                //     }
                // }
            ]
        ]
    });
};
