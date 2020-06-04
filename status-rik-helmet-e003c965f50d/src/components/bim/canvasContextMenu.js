import { ContextMenu } from './ContextMenu';

export default viewer => {
    return new ContextMenu({
        enabled: true,
        context: { 
            viewer: viewer
        },
        items: [
            [
                {
                    title: 'Сфокусировать вид',
                    doAction: function(context) {
                        context.viewer.cameraFlight.flyTo({
                            aabb: context.viewer.scene.getAABB()
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
                    },
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
        ]
    });
};
