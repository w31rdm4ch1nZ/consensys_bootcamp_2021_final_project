// contract address on the current testnet
// const ssAddress = '0x...'

/* add contract ABI
const ssABI =
[
	{
		"inputs": [],
    ...
*/

/**
 * Getting Accounts
 */


// window.ethereum
web3 = new Web3(window.ethereum)
const accounts = ethereum.request({ method: 'eth_accounts' });

//const ethereumButton = document.querySelector('.enableEthereumButton');
//const showAccount = document.querySelector('.showAccount');

//control I will make on the contrary to signal users they have to install metamask:
if (typeof window.ethereum !== 'undefined') {
  console.log('MetaMask is installed!');
}
else {
  console.log('You need Metamask browser extension installed to interact with this application!')
}

// Using the 'load' event listener for Javascript to
// check if window.ethereum is available

window.addEventListener('load', function() {
  
  if (typeof window.ethereum !== 'undefined') {
    console.log('window.ethereum is enabled')
    if (window.ethereum.isMetaMask === true) {
      console.log('MetaMask is active')
      let mmDetected = document.getElementById('mm-detected')
      mmDetected.innerHTML += 'MetaMask Is Available!'

      // add in web3 here => interesting part for us to continue!!
      var web3 = new Web3(window.ethereum)

    } else {
      console.log('MetaMask is not available')
      let mmDetected = document.getElementById('mm-detected')
      mmDetected.innerHTML += 'MetaMask Not Available!'
      // let node = document.createTextNode('<p>MetaMask Not Available!<p>')
      // mmDetected.appendChild(node)
    }
  } else {
    console.log('window.ethereum is not found')
    let mmDetected = document.getElementById('mm-detected')
    mmDetected.innerHTML += '<p>MetaMask Not Available!<p>'
  }
})

ethereumButton.addEventListener('click', () => {
  //Will Start the metamask extension
  ethereum.request({ method: 'eth_requestAccounts' });
});

ethereumButton.addEventListener('click', () => {
  getAccount();
});

// Grabbing the button object,  

const mmEnable = document.getElementById('mm-connect');

// since MetaMask has been detected, we know
// `ethereum` is an object, so we'll do the canonical
// MM request to connect the account. 
// 
// typically we only request access to MetaMask when we
// need the user to do something, but this is just for
// an example
 
mmEnable.onclick = async () => {
  await ethereum.request({ method: 'eth_requestAccounts'})
  // grab mm-current-account
  // and populate it with the current address
  var mmCurrentAccount = document.getElementById('mm-current-account');
  mmCurrentAccount.innerHTML = 'Current Account: ' + ethereum.selectedAddress
}

/*
//at this point only use one account (account[0])
async function getAccount() {
  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  const account = accounts[0];
  showAccount.innerHTML = account;
}
*/

//detect account change and you can add a message to warn the user trhough your frontend
ethereum.on('accountsChanged', function (accounts) {
    // Time to reload your interface with accounts[0]!
  });

/*
//example of sending a transaction, using the ethereum.request method directly. It will involve composing an options object like this:
const transactionParameters = {
    nonce: '0x01', // ignored by MetaMask
    gasPrice: '0x09184e72a000', // customizable by user during MetaMask confirmation.
    gas: '0x2710', // customizable by user during MetaMask confirmation.
    to: '0x7bAB139E87E29e6EA10673056D9b25AdEF42f939', // Required except during contract publications.
    from: ethereum.selectedAddress, // must match user's active address.
    value: '0x000000000001', // Only required to send ether to the recipient from the initiating external account.
    data:
        '0x7f7465737432000000000000000000000000000000000000000000000000000000600057', // Optional, but used for defining smart contract creation and interaction.
    chainId: '0x3', // Used to prevent transaction reuse across blockchains. Auto-filled by MetaMask.
    };

    // txHash is a hex string
    // As with any RPC call, it may throw an error
    const txHash = ethereum.request({
    method: 'eth_sendTransaction',
    params: [transactionParameters],
});
*/

/*
// window.ethereum
try {
  const transactionHash = await ethereum.request({
    method: 'eth_sendTransaction',
    params: [
      {
        nonce: '0x00', // ignored by MetaMask
        gasPrice: '0x09184e72a000', // customizable by user during MetaMask confirmation.
        gas: '0x2710', // customizable by user during MetaMask confirmation.
        to: '',
        'from': '0x4BfA49df48d66ea41b5cd491AA95fA0E88D6D847',
        value: '0x7bAB139E87E29e6EA10673056D9b25AdEF42f939',
        value: '0x00', // Only required to send ether to the recipient from the initiating external account.
        data:
        '0x7f7465737432000000000000000000000000000000000000000000000000000000600057', // Optional, but used for defining smart contract creation and interaction.
        chainId: '0x3', // Used to prevent transaction reuse across blockchains. Auto-filled by MetaMask
      },
    ],
  });
  // Handle the result
  console.log(transactionHash);
} catch (error) {
  console.error(error);
}

*/