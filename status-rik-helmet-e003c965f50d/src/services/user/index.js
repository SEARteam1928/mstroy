import Api from '@services/api';
import { isFalse } from '@services/utils';
import { mapGetters, mapMutations, mapActions } from 'vuex';

class User {
    constructor(Router) {
        if (typeof User.instance === 'object') {
            if (Router) User.instance.Router = Router;
            return User.instance;
        }

        User.instance = this;

        this.id = null;
        this.email = null;
        this.username = null;
        this.token = null;
        this.userInfo = null;

        this.getUserRequest = null;
        this.Router = Router;

        Object.defineProperties(this, {
            // Для админа все проверки должны будут возвращать true
            isAdmin: {
                configurable: true,
                enumerable: true,
                get() {
                    return this.roles && this.roles.admin ? true : false;
                }
            },
            // Вернет true, если пользователь установлен
            isAuthorized: {
                configurable: true,
                enumerable: true,
                get() {
                    return Api.token && !isFalse(this.id) ? true : false;
                }
            }
        });

        this.autoInit();
    }

    autoInit() {
        let id = window.localStorage.getItem('userId');
        let token = window.localStorage.getItem('token');

        if (id === null || token === null) {
            this.resetUser();

            return;
        }

        id = Number(id);

        this.setUser(id, token);
    }

    setRouter = Router => {
        this.Router = Router;

        return this;
    };

    setStore = Store => {
        this.$store = Store;

        let getters = mapGetters('User', ['checkScenarios', 'isAuthorized', 'isAdmin']);
        this.setStoreComponents(getters, true);

        let mutations = mapMutations('User', [
            'setId',
            'setEmail',
            'setUsername',
            'setToken',
            'clearRoles',
            'clearScenarios',
            'clearUserInfo'
        ]);
        this.setStoreComponents(mutations);

        let actions = mapActions('User', ['setRoles']);
        this.setStoreComponents(actions);

        if (this.userInfo && this.userInfo.roles) {
            let { rowId, email, username, roles } = this.userInfo;
            this.setId(rowId);
            this.setEmail(email);
            this.setUsername(username);

            this.setRoles(roles);
        }

        return this;
    };

    update = () => {
        if (this.$store) {
            this.roles = this.$store.state.User.roles;
            this.scenarios = this.$store.state.User.scenarios;
        } else if (!this.roles || !this.scenarios) {
            this.roles = {};
            this.scenarios = {};
        }
    };

    // Пробрасывает в this методы, полученные из хэлперов vuex
    setStoreComponents(component, call = false) {
        for (let key in component) {
            if (component.hasOwnProperty(key)) {
                let element = component[key];

                let descriptor = {
                    configurable: true,
                    enumerable: true
                };

                if (call) {
                    descriptor.get = element.bind(this);
                } else {
                    descriptor.value = element;
                }

                Object.defineProperties(this, {
                    [key]: descriptor
                });
            }
        }
    }

    setId(id) {
        this.id = id;
    }

    setEmail(email) {
        this.email = email;
    }

    setUsername(username) {
        this.username = username;
    }

    setToken(token) {
        this.token = token;
    }

    clearUserInfo() {
        this.id = null;
        this.email = null;
        this.username = null;
    }

    // Принимает id и токен юзера, по id делает запрос на апи для получения
    // информации о юзере с его ролями и сценариями
    setUser = async (id = null, token = null, redirect = false) => {
        if (id === null || token === null) return;

        Api.setToken(token);

        let response = null;

        this.getUserRequest = new Promise(async (resolve, reject) => {
            try {
                response = await Api.getUser(id);
                let userInfo = response.data.allUsers[0];
                if (!userInfo) reject('Пользователь не найден');

                this.userInfo = userInfo;
                let { rowId, email, username, roles } = userInfo;

                this.setId(rowId);
                this.setEmail(email);
                this.setUsername(username);
                this.setToken(token);

                this.setRoles(roles);

                window.localStorage.setItem('userId', id);
                window.localStorage.setItem('token', token);

                resolve(this);

                if (redirect) this.redirectTo('/');
            } catch (error) {
                reject(error);
            }
        });

        return this.getUserRequest;
    };

    // Сброс пользователя
    resetUser = () => {
        Api.resetToken();

        this.clearUserInfo();
        this.userInfo = null;

        delete this.roles;
        delete this.scenarios;
        this.getUserRequest = null;

        if (typeof this.clearRoles === 'function') this.clearRoles();
        if (typeof this.clearScenarios === 'function') this.clearScenarios();

        window.localStorage.removeItem('userId');
        window.localStorage.removeItem('token');

        this.redirectTo('login');

        return this;
    };

    redirectTo = (locationName = '/') => {
        let locationPath = locationName.startsWith('/') ? locationName : `/${locationName}`;
        if (this.Router) {
            if (this.Router.currentRoute.path === locationPath) return;

            this.Router.push({ path: locationPath }).catch();
        } else {
            if (window.location.pathname === locationPath) return;
            window.location.replace(locationPath);
        }

        return this;
    };

    setRoles(roles) {
        this.roles = {};
        this.scenarios = {};

        if (!(roles instanceof Array)) return;

        roles.forEach(role => {
            this.roles[role.name] = role;

            this.setScenarios(role.scenarios);
        });
    }

    setScenarios(scenarios) {
        if (!(scenarios instanceof Array)) return;

        scenarios.forEach(scenario => {
            let name = scenario.name.toLowerCase();
            this.scenarios[name] = scenario;
        });
    }

    // Проверяет наличие сценария(массива сценариев) у пользователя
    // Если !andMode и передан массив сценариев, то при наличии хотя бы одного сценария у юзера, метод вернет true
    // Если andMode и передан массив сценариев,
    // то все переданные сценарии должны присутствовать у юзера, чтобы метод вернул true
    checkScenarios = (scenarios = '', andMode = false) => {
        if (!(scenarios instanceof Array)) scenarios = [scenarios];

        this.update();

        if (this.isAdmin) return true;

        let allow = false;

        for (let index = 0; index < scenarios.length; index++) {
            let scenario = scenarios[index].toLowerCase();

            if (andMode) {
                if (this.scenarios[scenario]) {
                    allow = true;
                } else {
                    allow = false;
                    break;
                }
            } else {
                if (this.scenarios[scenario]) {
                    allow = true;
                    break;
                }
            }
        }

        return allow;
    };
}

// TODO: Убрать на проде
if (process.env.DEV) {
    window.User = new User();
    window.checkScenarios = new User().checkScenarios;
}

export default new User();
export const checkScenarios = new User().checkScenarios;
export const isAdmin = new User().isAdmin;
