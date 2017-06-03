# Crypto-wallet for ICO campaign

How to launch ICO? This is tool for it.

Examples of successful ICO: [http://blockstarter.co](http://blockstarter.co)


Install 
=======
This is a white label solution to create a contribution crypto-wallet that can be used in your ICO campaign.

## Install 

NodeJS is required.

```
npm i blockstarter
```

## Usage

In your Nodejs project:

```Javascript
let blockstarter = require('blockstarter');
```

### Get balance of cryptocurrency address

```js
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
```

### Get cryptocurrency rates

```js
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

## More code examples


More info
```
Please check out `test` folder
```


Please check out [./test](./test) folder for more usage examples.

## Need help or integration?

If you need a help or integration with your sytem, please contact us at [blockstarter.co](http://blockstarter.co)

Support

```
a.stegno@gmail.com
leksandr.siman@gmail.com 
```