import { startsWithSlash } from '@services/utils';
import { buildDirentsQuery } from '../utils';

// Операции с репозиториями
export async function getRepos() {
    let url = `${this.seaFileApi}/api2/repos/`;
    let res = await this.axios(url);

    return res.data;
}

// Операции с папками
export async function getDir(libID, path = '') {
    let url = `${this.seaFileApi}/api2/repos/${libID}/dir/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';
    let res = await this.axios(url);

    return res.data;
}

export async function createDir(libID, path) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/dir/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';

    let data = new FormData();
    data.set('operation', 'mkdir');
    let headers = { 'Content-Type': 'multipart/form-data' };

    let res = await this.axios.post(url, data, { headers });

    return res.data;
}

export async function deleteDir(libID, path) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/dir/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';

    let res = await this.axios.delete(url);

    return res.data;
}

export async function renameDir(libID, path, newName) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/dir/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';

    let data = new FormData();
    data.set('operation', 'rename');
    data.set('newname', newName);
    let headers = { 'Content-Type': 'multipart/form-data' };

    let res = await this.axios.post(url, data, { headers });

    return res.data;
}

// Операции с файлами
export async function downloadFile(libID, path) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/file/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';

    let res = await this.axios(url);

    // Здесь возвращается прямая ссылка к файлу для скачивания
    return this.statusFreya + res.data;
}

export async function getUploadLinkFile(libID, path) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/upload-link/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';
    let res = await this.axios(url);

    // Здесь возвращается ссылка на которую надо загружать файл
    return this.statusFreya + res.data;
}

export async function getUploadedBytesFile(libID, path, name) {
    let url = `${this.seaFileApi}/api/v2.1/repos/${libID}/file-uploaded-bytes/`;
    url += path ? `?parent_dir=${startsWithSlash(path)}` : '';
    url += name ? `&file_name=${startsWithSlash(name)}` : '';
    let res = await this.axios(url);

    return res.data;
}

export async function uploadChunkFile({ url, path, name, chunkBlob, bytesUploaded = 0, total }) {
    let { URL } = window;
    let file = URL.createObjectURL(chunkBlob);

    let data = new FormData();
    // data.append('file', file);
    // data.append('file', new File([chunkBlob], name, { type: 'image/jpeg' }));
    data.append('file', chunkBlob);
    data.append('parent_dir', `${startsWithSlash(path)}`);

    let range = `${bytesUploaded}-${bytesUploaded + chunkBlob.size}`;

    let headers = {
        'Content-Type': 'multipart/form-data',
        'Content-Range': `bytes ${range}/${total}`,
        'Content-Disposition': `attachment; filename="${name}"`
    };

    let res = await this.axios.post(url, data, { headers });

    return res.data;
}

export async function uploadFile(url, path, file) {
    let data = new FormData();
    data.append('file', file);
    data.append('parent_dir', `${startsWithSlash(path)}`);

    let headers = { 'Content-Type': 'multipart/form-data' };

    let res = await this.axios.post(url, data, { headers });

    return res.data;
}

export async function deleteFile(libID, path) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/file/`;
    url += `?p=${startsWithSlash(path)}`;

    let res = await this.axios.delete(url);

    return res.data;
}

export async function renameFile(libID, path, newName) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/file/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';

    let data = new FormData();
    data.set('operation', 'rename');
    data.set('newname', newName);
    let headers = { 'Content-Type': 'multipart/form-data' };

    let res = {};

    // BUG: Эта конструкция нужна для заплатки бага переименования файлов не из корневой папки хранилища
    try {
        res = await this.axios.post(url, data, { headers });
    } catch (error) {
        // Когда переименовывается файл из вложенной папки, то операция проходит успешно,
        // но в ответ прилетает статус 404
        let { response } = error;

        // Если статус 404, будем считать, что переименование прошло успешно, и вернем ответ,
        // хотя в ответе будет {error_msg: "File not found"}
        if (response.status === 404) {
            return response.data;

            // Если ошибка появилась не из-за статуса 404, выбрасываем ее дальше
        } else {
            throw error;
        }
    }

    return res.data;
}

export async function moveFile(libID, path, destinationPath) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/file/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';

    let data = new FormData();
    data.set('operation', 'move');
    data.set('dst_repo', libID);
    data.set('dst_dir', `${startsWithSlash(destinationPath)}`);

    let headers = { 'Content-Type': 'multipart/form-data' };

    let res = await this.axios.post(url, data, { headers });

    return res.data;
}

export async function copyFile(libID, path, destinationPath) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/file/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';

    let data = new FormData();
    data.set('operation', 'copy');
    data.set('dst_repo', libID);
    data.set('dst_dir', `${startsWithSlash(destinationPath)}`);

    let headers = { 'Content-Type': 'multipart/form-data' };

    let res = await this.axios.post(url, data, { headers });

    return res.data;
}

export async function syncCopyItems(libID, path, items, destinationPath) {
    let url = `${this.seaFileApi}/api/v2.1/repos/sync-batch-copy-item/`;

    let data = {
        src_repo_id: libID,
        src_parent_dir: startsWithSlash(path),
        src_dirents: items,

        dst_repo_id: libID,
        dst_parent_dir: startsWithSlash(destinationPath)
    };

    let res = await this.axios.post(url, data);

    return res.data;
}

export async function syncMoveItems(libID, path, items, destinationPath) {
    let url = `${this.seaFileApi}/api/v2.1/repos/sync-batch-move-item/`;

    let data = {
        src_repo_id: libID,
        src_parent_dir: startsWithSlash(path),
        src_dirents: items,

        dst_repo_id: libID,
        dst_parent_dir: startsWithSlash(destinationPath)
    };

    let res = await this.axios.post(url, data);

    return res.data;
}

export async function syncDeleteItems(libID, path, items) {
    let url = `${this.seaFileApi}/api/v2.1/repos/batch-delete-item/`;

    let data = {
        repo_id: libID,
        parent_dir: startsWithSlash(path),
        dirents: items
    };

    let res = await this.axios.delete(url, { data });

    return res.data;
}

export async function asyncDownloadMultipleItems(libID, parentDir, dirents) {
    let url = `${this.seaFileApi}/api/v2.1/repos/${libID}/zip-task/`;

    let queryString = `?parent_dir=${startsWithSlash(parentDir)}&`;
    queryString += buildDirentsQuery(dirents);

    let res = await this.axios(url + queryString);

    return res.data;
}

export async function checkZipToken(zipToken) {
    let url = `${this.seaFileApi}/api/v2.1/query-zip-progress/?token=${zipToken}`;
    let res = await this.axios(url);

    return res.data;
}

export async function getUrlByZipToken(zipToken) {
    let url = `${this.statusFreya}/p/sf/zip/${zipToken}`;

    return url;
}

export async function getFileContent(url) {
    let res = await this.axios(url, { responseType: 'blob' });

    return res.data;
}

export async function getUpdateLinkFile(libID, path) {
    let url = `${this.seaFileApi}/api2/repos/${libID}/update-link/`;
    url += path ? `?p=${startsWithSlash(path)}` : '';
    let res = await this.axios(url);

    // Здесь возвращается ссылка на которую надо загружать файл
    return this.statusFreya + res.data;
}

export async function updateFile(url, path, file) {
    let data = new FormData();
    data.append('file', file);
    data.append('target_file', `${startsWithSlash(path)}`);

    let headers = { 'Content-Type': 'multipart/form-data' };

    let res = await this.axios.post(url, data, { headers });

    return res.data;
}
