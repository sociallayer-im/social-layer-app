import { ethers } from 'ethers';
import { SiweMessage } from 'siwe';

const domain = window.location.host;
const origin = window.location.origin;
const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();

const BACKEND_ADDR = "http://localhost:3000";
async function createSiweMessage(address, statement) {
    const res = await fetch(`${BACKEND_ADDR}/siwe/nonce`, {
    });
    let nonce = (await res.json()).nonce
    window.nonce = nonce
    console.log('non', nonce)
    const message = new SiweMessage({
        domain,
        address,
        statement,
        uri: origin,
        version: '1',
        chainId: '1',
        nonce: nonce
    });
    return message.prepareMessage();
}

function connectWallet() {
    provider.send('eth_requestAccounts', [])
        .catch(() => console.log('user rejected request'));
}

async function signInWithEthereum() {
    const message = await createSiweMessage(
        await signer.getAddress(),
        'Sign in with Ethereum to the app.'
    );
    const signature = await signer.signMessage(message);

    const res = await fetch(`${BACKEND_ADDR}/siwe/verify`, {
        method: "POST",
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ message, signature, nonce: window.nonce }),
    });
    let authToken = (await res.json()).auth_token
    window.authToken = authToken
    console.log(authToken);
}

async function getInformation() {
    const res = await fetch(`${BACKEND_ADDR}/siwe/current?auth_token=${window.authToken}`, {

    });
    console.log(await res.text());
}

const connectWalletBtn = document.getElementById('connectWalletBtn');
const siweBtn = document.getElementById('siweBtn');
const infoBtn = document.getElementById('infoBtn');
connectWalletBtn.onclick = connectWallet;
siweBtn.onclick = signInWithEthereum;
infoBtn.onclick = getInformation;