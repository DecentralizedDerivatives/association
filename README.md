# DDA Cooperative Smart Contract Guide

![CryptoPets](./public/dday.png)



# Contracts

## The Cooperative Token

### Structure

#### General

There are four contracts that have inherit relationships leading to the Cooperative Token

SafeMath -> Token -> Base -> Cooperative



#### Token Structure



### Functions and Variable

  

#### Setup and Basic Functions

 

#### Notes:

All contracts are owned by DDA


## Testing
```
truffle compile
truffle develop
test
```

Further testing runs (with no contract changes) only require `truffle test`.

Should you make any changes to the contract files, make sure you `rm -rf build` before running `truffle compile && truffle test`.
