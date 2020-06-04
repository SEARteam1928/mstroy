import Vue from 'vue';
import axios from 'axios';

Vue.prototype.$axios = axios;
const axiosInstance = axios.create({
    baseURL: 'https://helmetapi.ms11.ru/'
    // baseURL: 'http://status-freya.ms11.biz:5000'
});
Vue.prototype.$axios = axiosInstance;
export { axiosInstance };
