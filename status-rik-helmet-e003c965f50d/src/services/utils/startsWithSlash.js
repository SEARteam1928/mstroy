export default str => (str.startsWith('/') ? str : `/${str}`);
