big-number = require \big.js

expect = require \expect

run <-! describe \Basic

it \test-big-number, ->
  expect(big-number(5).to-string!).to-be("5")
  expect(big-number("5").to-string!).to-be("5")
  expect(big-number("7601.11229246").to-string!).to-be("7601.11229246")
  expect(big-number("-7601.11229246").to-string!).to-be("-7601.11229246")
  expect(big-number("802672.276608465139479303").to-string!).to-be("802672.276608465139479303")