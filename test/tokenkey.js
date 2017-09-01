var Token = artifacts.require("./TokenKey.sol");
const BigNumber = web3.BigNumber
const should = require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

contract('ERC20 TokenKey Tests', function(accounts) {

  beforeEach(async function() {
    this.contract = await Token.new()
  })

  it("Token contract should record and provide starting block", async function() {
    const startingBlock = await this.contract.blockNumber()
    startingBlock.should.be.bignumber.greaterThan(0,'The starting block should be greater than zero.')
  })

  it("Token contract should issue 5000 tokens on deploy", async function() {
    const currentTokens = await this.contract.balanceOf(accounts[0])
    currentTokens.should.be.bignumber.equal(5000,'The inital token disbursement was wrong.')
  })

  it("Token holder should be able to transfer tokens", async function() {
    await this.contract.transfer(accounts[1],400)
    const currentTokens = await this.contract.balanceOf(accounts[0])    
    currentTokens.should.be.bignumber.equal(4600,'The tokens transfer failed.')
  })

  it("Non token holder should not be able to transfer tokens", async function() {
    await this.contract.transfer(accounts[0],400,{from: accounts[1]})
    const currentTokens = await this.contract.balanceOf(accounts[0])
    currentTokens.should.be.bignumber.equal(5000,'The tokens transfered!')
  })

  it("Approved to spend accounts should be able to use transfer From", async function() {
    await this.contract.approve(accounts[1],400)
    const allowedToSpend = await this.contract.allowance(accounts[0], accounts[1])
    allowedToSpend.should.be.bignumber.equal(400,'The amount allowed was not correct!')
  })

  it("Token holders should be able to spend tokens to generate keys", async function() {
    const transaction = await this.contract.generateKey('https://www.facebook.com/')
    const key = transaction.logs[0].args.key 
    key.should.be.equal('0xbb81b6d5e3b2cc6b9474806beb07a1941abacbc5b8467daea2d85c7bc5fd3fad','The key was not as expected.')
  })

  it("Key owner should be able to mark a key for sale", async function() {
    const key = '0xbb81b6d5e3b2cc6b9474806beb07a1941abacbc5b8467daea2d85c7bc5fd3fad'
    const transaction = await this.contract.generateKey('https://www.facebook.com/')
    await this.contract.approveSale(key,accounts[1],200)
    const sale = await this.contract.activeSales(key)
    sale[0].should.be.equal(accounts[1],'The key did not get marked for sale correctly.')
  })

  it("Token holder should be able to purchase key if approved", async function() {

    await this.contract.transfer(accounts[1],400)
    const transaction = await this.contract.generateKey('https://www.facebook.com/')
    const key = transaction.logs[0].args.key     
    const originalOwner = await this.contract.getKeyOwner(key)

    await this.contract.approveSale(key,accounts[1],200)
    await this.contract.purchaseKey(key, 200, {from: accounts[1]})
    const newOwner = await this.contract.getKeyOwner(key)
    newOwner.should.not.be.equal(originalOwner,'Ownership of the key did not transfer.')
    newOwner.should.be.equal(accounts[1],'The new owner was not as expected.')    
  })



})
