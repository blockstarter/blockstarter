require! { 
    expect 
    \big.js
}

run <-! describe \Number

it \test-big, ->
  s = -> big(it).to-string!
  expect(s 5).to-be("5")
  expect(s "5").to-be("5")
  expect(s "7601.11229246").to-be("7601.11229246")
  expect(s "-7601.11229246").to-be("-7601.11229246")
  expect(s "802672.276608465139479303").to-be("802672.276608465139479303")