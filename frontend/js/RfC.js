//To set date in smart-contract with web3.js:

let date = (new Date()).getTime();
let birthDateInUnixTimestamp = date / 1000;
await BirthDate.methods.set(birthDateInUnixTimestamp).send(opts);

//To get date from smart-contract with web3.js:

let birthDateInUnixTimestamp = await BirthDate.methods.get().call();
let date = new Date(birthDateInUnixTimestamp * 1000);