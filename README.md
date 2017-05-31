# Crypto-wallet for ICO campaign

This is a white label solution by BlockStarter to create contribution crypto-wallet that can be usdd in you ICO campaign.

## Install 

NodeJS is required.

```
npm i blockstarter
```

## Usage

```Javascript

let blockstarter = require('blockstarter');

// Get balance of BTC address
blockstarter.balance.btc('BTC_PUBLIC_ADDRESS', (amount) => {
   console.log(amount.toString());
})

// Get balance of LTC address
blockstarter.balance.ltc('LTC_PUBLIC_ADDRESS', (amount) => {
   console.log(amount.toString());
})

// Get balance of ETH address
blockstarter.balance.eth('ETH_PUBLIC_ADDRESS', (amount) => {
   console.log(amount.toString());
})

// Get BTC/USD rate
blockstarter.rate.btc( (usd) => {
   console.log(usd);
})

// Get LTC/USD rate
blockstarter.rate.ltc( (usd) => {
   console.log(usd);
})

// Get ETH/USD rate
blockstarter.rate.eth( (usd) => {
   console.log(usd);
})
```

## More info

Please check out [./test](./test) folder.
