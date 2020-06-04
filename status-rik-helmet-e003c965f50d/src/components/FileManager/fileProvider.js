const fileProvider = new CustomFileProvider({
    getItems: async function(pathInfo) {
        // Your code goes here
        // console.log('getItems: ', pathInfo);

        // await delay(1000);

        // return fileItems;
        // // return [];

        let path = pathInfo[pathInfo.length - 1];
        path = path ? path.key : '';

        let result = await Api.getDir(this.seaLibID, path);

        return result;
    },
    renameItem: function(item, name) {
        console.log('renameItem: ', item, name);

        // Your code goes here
    },
    createDirectory: async function(parentDir, name) {
        // Your code goes here

        await delay(1000);

        console.log('createDirectory: ', parentDir, name);

        await delay(1000);

        // return true;
        // return false;
        // throw new Error('11111');
    },
    deleteItem: function(item) {
        console.log('deleteItem: ', item);

        // Your code goes here
    },
    moveItem: function(item, destinationDir) {
        console.log('moveItem: ', item, destinationDir);

        // Your code goes here
    },
    copyItem: function(item, destinationDir) {
        console.log('copyItem: ', item, destinationDir);

        // Your code goes here
    },
    uploadFileChunk: async function(fileData, chunksInfo, destinationDir) {
        console.log('uploadFileChunk: ', fileData, chunksInfo, destinationDir);

        // await delay(100);

        // Your code goes here
    },
    abortFileUpload: function(fileData, chunksInfo, destinationDir) {
        console.log('abortFileUpload: ', fileData, chunksInfo, destinationDir);

        // Your code goes here
    },
    uploadChunkSize: 1000
});
