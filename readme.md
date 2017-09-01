
## Standard ERC20 Token contract with keys

This is standard token contract that allows token holders create keys from a url and sell them for tokens. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

To run this locally you will need the [Truffle framework](http://truffleframework.com/), node.js, npm, and a local development ethereum node


### Installing

Install truffle

```

$ npm install -g truffle

```

Once you have cloned the project, from inside the project directory you'll need to run npm install to get the 
testing libraries. 

```

$ npm install

```

Start up your ethereum node then compile and deploy your contracts. You'll need two unlocked accounts on your
ethereum client to be able to run the token transfer tests successfully.

```

$ truffle compile
$ truffle migrate

```


## Running the tests

Once the contracts are deployed to your development ethereum node you can run the test like this. 

```

$ truffle test

```

### Test Overview

There are several tests that cover basic ERC20 Token functionality, and three tests that look at the Key related functionality. 


## Authors

* **David Akers** - *Initial work* - [davidmichaelakers](https://github.com/davidmichaelakers)


## Acknowledgments

* [SimplyVital Health](https://www.simplyvitalhealth.com/) 
