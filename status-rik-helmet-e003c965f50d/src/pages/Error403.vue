<template>
    <div class="fixed-center text-center">
        <p>
            <img src="~assets/unprotected.svg" style="width:30vw;max-width:150px;" />
        </p>
        <p class="text-faded">Недостаточно прав для просмотра этой страницы <strong>(403)</strong></p>
        <q-btn color="primary" style="width:200px;" @click="$router.replace({ name: 'home' })">На главную</q-btn>
    </div>
</template>

<script>
export default {
    name: 'Error403',
    meta: {
        title: 'Защищенная страница',
        titleTemplate: title => `${title} - BIM-портал`
    }
};
</script>
