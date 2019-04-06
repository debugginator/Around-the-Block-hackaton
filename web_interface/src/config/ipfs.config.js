const IPFS = require('ipfs-http-client');

// IPFS configured to use the infura.io API instead of local development
const ipfs = new IPFS({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' });

export default ipfs;