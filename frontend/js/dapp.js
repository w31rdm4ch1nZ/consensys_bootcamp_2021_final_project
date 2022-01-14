import MetaMaskOnboarding from '@metamask/onboarding'

const forwarderOrigin = 'http://127.0.0.1:5500'

const initialize = () => {
  //You will start here 
  const onboardButton = document.getElementById('connectButton');

  //Created check function to see if the MetaMask extension is installed
  const isMetaMaskInstalled = () => {
    //Have to check the ethereum binding on the window object to see if it's installed
    const { ethereum } = window;
    return Boolean(ethereum && ethereum.isMetaMask);
  };
 

  // Dapp Status Section
  const networkDiv = document.getElementById('network')
  const chainIdDiv = document.getElementById('chainId')
  const accountsDiv = document.getElementById('accounts')

  // Basic Actions Section
  const onboardButton = document.getElementById('connectButton')
  const getAccountsButton = document.getElementById('getAccounts')
  const getAccountsResults = document.getElementById('getAccountsResult')

  /****
   * 
   *  *  * REQUEST FOR CONTENT SECTION for RfC Dashboard
   *  
   ****/

  // Go to make a proposal
  const urlToRfCProposal = document.getElementById('goToRfCProposal')


  /****
   * 
   *  *  * CONTENT PROVIDER SECTION for CP Dashboard
   *  
   ****/


  const deployButton = document.getElementById('deployButton')
  const depositButton = document.getElementById('depositButton')
  const withdrawButton = document.getElementById('withdrawButton')
  const contractStatus = document.getElementById('contractStatus')

  // Send Eth Section for Investor (pass the ID # of the RfC the user wants to invest in)
  const sendButton = document.getElementById('investRfCidX')


  /****
   *  
   * * * INVESTOR DASHBOARD SECTION for Investor Dashboard
   * 
   ****/

  // Investor Dashboard Section
  const idRfC = document.getElementById('RfCid')
  const investEth = document.getElementById('amountInvestedEth')
  const investButton = document.getElementById('investButton')  // call function in FundsManager contract with parameters passed

  // Display information regarding your investment in a Request for Content:
  //  Implies to read states form the contracts + updates with events in the contract:
  const investmentsList = document.getElementById('investmentsList')  //to add in the frontend
  const inputRFCidToDisplay = document.getElementById('RfCidToDisplay')
  const displayButton = document.getElementById('displayInvestmentInfoButton')

  // Signed Type Data Section
  const signTypedData = document.getElementById('signTypedData')
  const signTypedDataResults = document.getElementById('signTypedDataResult')



  const onClickConnect = async () => {
    try {
      // Will open the MetaMask UI
      // You should disable this button while the request is pending!
      await ethereum.request({ method: 'eth_requestAccounts' });
    } catch (error) {
      console.error(error);
    }
  };

  const MetaMaskClientCheck = () => {
    //Now we check to see if MetaMask is installed
    if (!isMetaMaskInstalled()) {
      //If it isn't installed we ask the user to click to install it
      onboardButton.innerText = 'Click here to install MetaMask!';
      //When the button is clicked we call this function
      onboardButton.onclick = onClickInstall;
      //The button is now disabled
      onboardButton.disabled = false;
    } else {
      //If it is installed we change our button text (would be great to have it displaying the account's address...)
      onboardButton.innerText = 'Connected to Ethereum';
      //When the button is clicked we call this function to connect the users MetaMask Wallet
      onboardButton.onclick = onClickConnect;
      //The button is now disabled
      onboardButton.disabled = false;
    }
  };

  MetaMaskClientCheck();
}



window.addEventListener('DOMContentLoaded', initialize)
