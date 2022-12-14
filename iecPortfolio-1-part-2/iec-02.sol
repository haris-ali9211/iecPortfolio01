// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract iecToken{

    address admin;

    string public constant name = "erc720-beta";
    string public constant symbol = "beta";
    uint public totalSupply = 1000 * 10 ** 8;
    uint256 public immutable decimals;  
 
    event Transfer(address indexed recipient, address indexed to, uint amount);
    event Allowance(address indexed from, address indexed to, uint amount);
    
    mapping(address=>uint) private balances;
    mapping(address=>mapping(address=>uint)) private allowed;

    constructor() 
    {
        admin = msg.sender;
        balances[msg.sender] = totalSupply;
        decimals = 18;
    } 

    modifier onlyAdmin() 
    {
        require(msg.sender == admin,"You are not allowed to do that");
        _;
    }

    function balanceOf(address user) public view returns(uint)
    {
        return balances[user];
    }

    function transfer(address reciever, uint amount) public returns(bool)
    {
        require(balances[msg.sender] >= amount,"You dont have enough tokens to transfer");
        balances[msg.sender] -= amount;
        balances[reciever] += amount;

        emit Transfer(msg.sender,reciever,amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint)
    {
       return allowed[_owner][_spender];
    }

    function approval(address _spender, uint _value) public returns(bool success) 
    {
         allowed[msg.sender][_spender] = _value;
         
         emit Allowance(msg.sender,_spender,_value);
         return true;
    } 

    function transferFrom(address _from, address _to, uint _value) public returns(bool success) 
    {
        uint allowedTokens = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowedTokens>=_value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}