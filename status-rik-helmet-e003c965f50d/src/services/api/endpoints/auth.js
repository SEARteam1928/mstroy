export async function login(authData) {
    let res = await this.axios.post(`${this.statusFreya}/auth/login`, authData);

    return res.data;
}
