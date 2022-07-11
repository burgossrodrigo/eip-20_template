//SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.15;

contract Token {

    constructor(string memory name_, string memory symbol_, uint totalSupply_) public {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = totalSupply_;
        _decimals = 18;
        _mint(msg.sender, _totalSupply);
    }

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint)) _allowed;
    uint _totalSupply;
    string _name;
    string _symbol;
    uint8 _decimals;

    event Transfer(address, address, uint);
    event Approval(address, address, uint);

    function name() public view returns (string memory){
        return _name;
    }
    function symbol() public view returns (string memory){
        return _symbol;
    }
    function decimals() public view returns (uint8){
        return _decimals;
    }

    /**
    * @dev function to check the total supply
    * @return uint representing the total supply
    */

    function totalSupply() public view returns(uint){
        return _totalSupply;
    }

    /** 
    * @dev function that return the balance of an specific address
    * @param owner the address that you want to know the balance
     */

    function balanceOf(address owner) public view returns(uint){
        return _balances[owner];
    }

    /**
    * @dev return the amount the the owner has authorized a third party address to spend
    * @param owner owner of the token
    * @param spender address responsible for spending in behalf of the owner
    * @return uint for the allowance
     */

    function allowance(address owner, address spender) public view returns(uint){
        return _allowed[owner][spender];
    }

    /**
    * @dev transfer tokens from the sender to an specific address
    * @param to address where the owner wants to send tokens
    * @param value value in which the owner wants to transfer in wei 
     */

    function transfer(address to, uint value) public returns (bool) {
        require(value <= _balances[msg.sender], "Not enough balance");
        require(to != address(0), "You can't burn tokens");
        //transfer fees go here!
        _balances[msg.sender] = _balances[msg.sender] - value;
        _balances[to] = _balances[to] + value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev approve an address to spend tokens on behalf of owner
    * @param spender address to spend in behalf of owner
    * @param value amount of tokens to be authorized 
     */

    function approve(address spender, uint value) public returns (bool) {
        require(spender != address(0), "You can't set allowance to address 0");
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev spend tokens in behalf of owner
    * @param from owner of the tokens
    * @param to address where the tokens will be sent
    * @param value amount of tokens to be spended
     */

    function transferFrom(address from, address to, uint value) public returns (bool) {
        require(value <= _balances[from], "Target addres doesn't have enough balance");
        require(value <= _allowed[from][msg.sender], "You are not allowed to transfer this amount of tokens");
        require(to != address(0), "You can't send tokens to address 0");

        _balances[from] = _balances[from] - value;
        _balances[to] = _balances[to] + value;
        _allowed[from][msg.sender] = _allowed[from][msg.sender] - value;
        emit Transfer(from, to, value);
        return true;
    }

    /**
    * @dev uprise the allowance of an address to spend in behalf of other
    * @param addedValue amount of tokens to be uprised on allowance
     */

    function increaseAllowance(address spender, uint addedValue) public returns (bool) {
        require(spender != address(0), "You can't delegate allowance to address 0");
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender] + addedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev downgrade the allowance for an address to spend in behalf of other
    * @param spender address to spend tokens in behalf of owner
    * @param subtractedValue value to be downgraded from the spender allowance
     */

    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
        require(spender != address(0), "You can't delegate allowance to address 0");
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender] - subtractedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev internal function to mint tokens
    * @param account where the new tokens will be minted
    * @param amount number of tokens that will be minted
     */

    function _mint(address account, uint amount) internal {
        require(account != address(0), "You can't mint tokens to address 0");
        _totalSupply = _totalSupply + amount;
        _balances[account] = _balances[account] + amount;
        emit Transfer(address(0), account, amount);
    }

    /**
    * @dev internal function to burn tokens
    * @param account where the tokens will be burned from
    * @param amount number of tokens to be burned
     */

    function _burn(address account, uint amount) internal {
        require(account != address(0));
        require(amount <= _balances[account], "Not enough balance to burn");
        _totalSupply = _totalSupply - amount;
        _balances[account] = _balances[account] - amount;
        emit Transfer(account, address(0), amount);
    }

    /**
    * @dev internal
     */

    function _burnFrom(address account, uint amount) internal {
        require(amount <= _allowed[account][msg.sender], "You are not allowed to burn this amount from the address");
        _allowed[account][msg.sender] = _allowed[account][msg.sender] - amount;
        _burn(account, amount);
    }
}