module.exports = {
    client: {
        service: {
            name: 'helmetapi',
            // URL to the GraphQL API
            // url: 'https://helmetapi.ms11.ru/graphql'
            // url: 'http://172.16.201.20:25304/'
            url: 'https://graphql.ms11.ru/',
            headers: {
                'Authorization':
                    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1ODY0MzQwMDc5MTAsImlhdCI6MTU4NjM0NzYwMjkxMCwicmxzIjpbMV0sInVzciI6NTJ9.2Gdif-ASUVa9XsBYVug896Z7iExm02Ly1iNVKAPv4L2rs-SWOVHXKJQ_hBpGQWcs4ZpKSkS_6mutoU6X7fz_5Q'
                    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1OTE5MjgxNDg2ODksImlhdCI6MTU5MTg0MTc0MzY4OSwicmxzIjpbMV0sInVzciI6ODh9.ppShgK4FjPSMQwTiJQx77buLjwB8TJNKUdseMp2K3MyHxb2YgxQtHA2GOjDsTnlE5fqxfSkYQyaQ5w6U-h7dng'
            }
        },
        // Files processed by the extension
        includes: ['src/**/*.vue', 'src/**/*.js', 'src/**/*.gql']
    }
};
