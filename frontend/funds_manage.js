//see for integration in the homepage, accessble to all users - maybe put it in the main js script
const requiredEth = (await myContract.getEstimatedETHforDAI(daiAmount).call())[0];
const sendEth = requiredEth * 1.1;

