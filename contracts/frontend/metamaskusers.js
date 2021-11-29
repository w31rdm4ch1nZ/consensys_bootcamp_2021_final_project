

//add an "app" button to the homepage that redirects to an app.yourdapp url/ipfs hash (or both) - try to find an easy way to have an ipfs stored frontend
// and a human-readble way to access it from the browser:

const ethereumButton = document.querySelector('.enableEthereumButton');
const showAccount = document.querySelector('.showAccount');

ethereumButton.addEventListener('click', () => {
  getAccount();
});


//at this point only use one account (account[0])
async function getAccount() {
  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  const account = accounts[0];
  showAccount.innerHTML = account;
}


//detect account change and you can add a message to warn the user trhough your frontend
ethereum.on('accountsChanged', function (accounts) {
    // Time to reload your interface with accounts[0]!
  });


//example of sending a transaction, using the ethereum.request method directly. It will involve composing an options object like this:
const transactionParameters = {
    nonce: '0x00', // ignored by MetaMask
    gasPrice: '0x09184e72a000', // customizable by user during MetaMask confirmation.
    gas: '0x2710', // customizable by user during MetaMask confirmation.
    to: '0x0000000000000000000000000000000000000000', // Required except during contract publications.
    from: ethereum.selectedAddress, // must match user's active address.
    value: '0x00', // Only required to send ether to the recipient from the initiating external account.
    data:
        '0x7f7465737432000000000000000000000000000000000000000000000000000000600057', // Optional, but used for defining smart contract creation and interaction.
    chainId: '0x3', // Used to prevent transaction reuse across blockchains. Auto-filled by MetaMask.
    };

    // txHash is a hex string
    // As with any RPC call, it may throw an error
    const txHash = await ethereum.request({
    method: 'eth_sendTransaction',
    params: [transactionParameters],
});