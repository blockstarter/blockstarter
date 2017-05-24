BlockStarter ICO helper

Install 

```
npm i blockstarter
```

Usage

```Javascript

var blockstarter = require('blockstarter');

//balences
blockstarter.balance.btc("BTC_PUBLIC_ADDRESS", (amount)=> {
   console.log(amount.toString());
})
   
blockstarter.balance.ltc("BTC_PUBLIC_ADDRESS", (amount)=> {
   console.log(amount.toString());
})

blockstarter.balance.eth("BTC_PUBLIC_ADDRESS", (amount)=>{
   console.log(amount.toString());
})


//rates
blockstarter.rate.btc( (usd)=> {
   console.log(usd);
})
   
blockstarter.rate.ltc( (usd)=>{
   console.log(usd);
})
   
blockstarter.rate.eth( (usd)=>{
   console.log(usd);
})
```


More info
```
Please check out `test` folder
```
