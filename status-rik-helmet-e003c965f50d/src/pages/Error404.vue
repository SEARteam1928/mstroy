<template>
    <div class="fixed-center text-center">
        <p>
            <img src="~assets/sad.svg" style="width:30vw;max-width:150px;" />
        </p>
        <p class="text-faded">Страница не найдена <strong>(404)</strong></p>
        <q-btn color="primary" style="width:200px;" @click="$router.replace({ name: 'home' })">На главную</q-btn>
    </div>
</template>

<script>
export default {
    name: 'Error404',
    meta: {
        title: 'Страница не найдена',
        titleTemplate: title => `${title} - BIM-портал`
    }
};
</script>
