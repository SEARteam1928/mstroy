import axios from 'axios';
import endpoints from './endpoints';

import ApolloClient from 'apollo-client/ApolloClient';
// import { SubscriptionClient } from 'subscriptions-transport-ws';
import { split } from 'apollo-link';
import { getMainDefinition } from 'apollo-utilities';
import { WebSocketLink } from 'apollo-link-ws';
import { createHttpLink } from 'apollo-link-http/lib/httpLink';
import { setContext } from 'apollo-link-context';
import { InMemoryCache } from 'apollo-cache-inmemory/lib/inMemoryCache';

class Api {
    constructor() {
        if (typeof Api.instance === 'object') {
            return Api.instance;
        }

        Api.instance = this;

        this.token = null;
        this.project = null;

        this.bimApi = process.env.BIM_API;
        this.statusFreya = process.env.STATUS_FREYA_API;
        this.graphql = process.env.GRAPH_QL_API;
        // this.seaFileApi = 'http://172.16.201.20:5555';
        this.seaFileApi = `${this.statusFreya}/p/sh`;

        // Смещение часового пояса клиента в минутах с инвертированным знаком
        this.timezoneOffset = new Date().getTimezoneOffset() * -1;

        this.axios = axios.create({});
        this.axios.defaults.headers.common['Time-Zone'] = this.timezoneOffset;

        this.axiosBimApi = axios.create({});

        this.axiosSeaFile = axios.create({});
        this.axiosSeaFile.defaults.headers.common['Authorization'] = 'Token 86d53b91fec3cd3961c7fff38cc3d14187a8fbce';

        // Установка заголовков для запроса к графу
        // Вызывается каждый раз при запросе и берет актуальный токен из this.token;
        const authLink = setContext((_, oldContext) => {
            let newHeaders = { ...oldContext.headers };

            newHeaders['Time-Zone'] = this.timezoneOffset;

            if (this.token) {
                newHeaders.Authorization = this.token;
            } else {
                delete newHeaders.Authorization;
            }

            if (this.project) newHeaders.Project = this.project;

            return {
                ...oldContext,
                headers: newHeaders
            };
        });

        let httpLink = createHttpLink({ uri: this.graphql });

        // Create WebSocket client
        // const wsClient = new SubscriptionClient(`ws://graphql.ms11.ru/subscriptions`, {
        //     reconnect: true,
        //     reconnectionAttempts: 10,
        //     lazy: true,
        //     connectionParams: () => {
        //         return {
        //             Authorization: this.token,
        //             headers: {
        //                 Authorization: this.token
        //             }
        //         };
        //     },
        //     connectionCallback: err => {
        //         console.log('connectionCallback: ', err);
        //     }
        // });
        // let wsLink = new WebSocketLink(wsClient);

        let wsLink = new WebSocketLink({
            uri: 'ws://graphql.ms11.ru/subscriptions',
            options: {
                reconnect: true,
                // reconnectionAttempts: 10,
                lazy: true,
                connectionParams: () => {
                    return {
                        Authorization: this.token,
                        headers: {
                            Authorization: this.token
                        }
                    };
                },
                connectionCallback: err => {
                    console.log('connectionCallback: ', err);
                }
            }
        });

        this.wsLink = wsLink;
        // console.log('Api -> wsLink', wsLink);

        // Простые запросы пойдут через http, подписки через ws
        const link = split(
            data => {
                const definition = getMainDefinition(data.query);
                return definition.kind === 'OperationDefinition' && definition.operation === 'subscription';
            },
            wsLink,
            httpLink
        );

        (this.link = link),
            (this.authLink = authLink.concat(link)),
            (this.apollo = new ApolloClient({
                link: this.authLink,
                cache: new InMemoryCache()
            }));
    }

    setToken(token) {
        if (!token) return;

        this.token = token;
        this.axios.defaults.headers.common['Authorization'] = token;
    }

    resetToken() {
        this.token = null;
        delete this.axios.defaults.headers.common['Authorization'];
    }

    setProject(project) {
        if (!project) return;

        this.project = project;
        this.axios.defaults.headers.common['Project'] = project;
    }
}

// Добавление эндпоинтов в прототип Api
for (const key in endpoints) {
    if (endpoints.hasOwnProperty(key)) {
        const endpoint = endpoints[key];

        Api.prototype[key] = endpoint;
    }
}

// TODO: Убрать на проде
if (process.env.DEV) {
    window.Api = new Api();
}

export default new Api();
