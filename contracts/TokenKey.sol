pragma solidity ^0.4.14;

contract TokenKey {

   uint public blockNumber = block.number;
   uint256 public totalSupply = 10000;
   mapping (address => uint256) balances;
   mapping (address => mapping (address => uint256)) allowed;

  struct Key {
    bytes url;
    bytes32 key;
    address owner;
    uint listPointer;
  }

  mapping(bytes32 => Key) public allKeys;
  bytes32[] public keyList;

  struct Sale {
    address purchaser;
    uint price;
  }
  mapping(bytes32 => Sale) public activeSales;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  event KeyCreated(address indexed _owner, bytes32 key);   
  event KeySold(address indexed _purchaser, bytes32 key, uint price);   

  //constructor
  function TokenKey() {
    balances[msg.sender] = 5000;
    totalSupply = totalSupply - 5000;
  }

  /* 
    Key Related Functions 
  */
  function generateKey(bytes _url) returns (bytes32 keyHash) {
     require(balances[msg.sender] > 20);
     balances[msg.sender] -= 20;
     totalSupply += 20;
     
     //create key
     keyHash = keccak256(_url);
     require(allKeys[keyHash].url.length == 0); //don't allow people to recreate existing keys

     allKeys[keyHash].url = _url;
     allKeys[keyHash].key = keyHash;     
     allKeys[keyHash].owner = msg.sender;          
     allKeys[keyHash].listPointer = keyList.push(keyHash) - 1;

     KeyCreated(msg.sender, keyHash);     
     return keyHash;  
  }

   function getKeyOwner(bytes32 keyHash) constant returns (address owner) {
       require(allKeys[keyHash].url.length > 0);
       owner = allKeys[keyHash].owner; 
   }

   function approveSale(bytes32 keyHash, address _purchaser, uint _price) returns (bool) {
      require(allKeys[keyHash].owner == msg.sender);
      activeSales[keyHash].purchaser = _purchaser;   
      activeSales[keyHash].price = _price;        
      return true;      
   }

   function purchaseKey(bytes32 keyHash, uint _payment) returns (bool) {
      require(activeSales[keyHash].purchaser == msg.sender);
      require(activeSales[keyHash].price == _payment);      
      require(balances[msg.sender] >= _payment);   
      balances[msg.sender] -= _payment;
      balances[allKeys[keyHash].owner] += _payment;
      allKeys[keyHash].owner = msg.sender;
      KeySold(msg.sender, keyHash, _payment); 
      return true;
   }

  /*
  Standard ERC20 functions
  */

    function transfer(address _to, uint256 _value) returns (bool success) {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

}