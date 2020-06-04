import createDeviceMutation from './graphql/devices/createDeviceMutation.gql';
import deleteDeviceMutation from './graphql/devices/deleteDeviceMutation.gql';
import updateDeviceMutation from './graphql/devices/updateDeviceMutation.gql';
import allDevicesQuery from './graphql/devices/allDevicesQuery.gql';
import allDeviceCoordinatesQuery from './graphql/devices/allDeviceCoordinatesQuery.gql';

// Получить массив устройств
export async function getDevices() {
    let res = await this.axios(`${this.statusFreya}/devices/`);

    return res;
}

export async function allDevices() {
    let result = await this.apollo.query({
        query: allDevicesQuery
    });

    return result;
}

export async function allDeviceCoordinates(filters, orderBy) {
    let result = await this.apollo.query({
        query: allDeviceCoordinatesQuery,
        variables: { filters, orderBy }
    });

    return result;
}

export async function getDevicesWithCoords(last = 10) {
    let res = await this.axios(`${this.statusFreya}/devices/with_coords?last=${last}`);

    return res.data;
}

export async function createDevice({ name, loraKey, assetsNumber, sendPeriod, ethalon }) {
    let result = await this.apollo.mutate({
        mutation: createDeviceMutation,
        variables: { name, loraKey, assetsNumber, sendPeriod, ethalon }
    });

    return result;
}

export async function deleteDevice(id) {
    let result = await this.apollo.mutate({
        mutation: deleteDeviceMutation,
        variables: { id }
    });

    return result;
}

export async function updateDevice({ id, name, loraKey, assetsNumber, sendPeriod, ethalon, rfidValue }) {
    let result = await this.apollo.mutate({
        mutation: updateDeviceMutation,
        variables: { id, name, loraKey, assetsNumber, sendPeriod, ethalon, rfidValue }
    });

    return result;
}
