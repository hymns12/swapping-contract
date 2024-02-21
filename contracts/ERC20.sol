// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// import "./IERC20.sol";


contract ERC20Token {

// state variables
    string  tokenName;
    string  symbol;
    uint256 decimals;
    address public owner;
    uint256 totalSupplys;

    // seting four the buying value
    uint256  tokenPrice;
    uint256  tokensSold;
    uint256  initialSupply;


    mapping(address => uint) balances; // mapping the address of the owner to get the balances of the owner
    mapping(address => mapping(address => uint256)) allowed; 
    
    event Approval(
    address indexed tokenOwner, 
    address indexed spender,
    uint tokens
    );

  event Transfer(
    address indexed from,
    address indexed to,
    uint tokens
    );

    constructor(uint256 _initialSupply, uint256 _tokenPrice) {
        tokenName = "WestFarGoToken";
        totalSupplys = 1000000;
        symbol = "WFGT";
        decimals = 18;
        owner = msg.sender;
        balances[msg.sender] += totalSupplys;

        tokenPrice = _tokenPrice;
        initialSupply = _initialSupply;
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
    

    function transfer(address _to, uint _token) public returns (bool) {

        // chacking if the Address provided by the receiver is not Address 0
        require(msg.sender != address(0), "This Address is not a vaild");

        // checking if the balances of the sender is greater than or equal the totalToken 
        require(balances[msg.sender] >= _token, "You dont have alot of Token");

        // calculating the 10 % when ever we make a transfar
        uint256 _fee = (_token * 10) / 100;  

        // Removing the token that wes withdorw form the sender accunts
        balances[owner] -= _fee;  

        // calculating the amount afer deducting the fee 
        uint256 afterDeduction = _token - _fee;

        // removing the token from the User Accunt
        balances[msg.sender] = balances[msg.sender] -_token;

        // adding the token to the receiver accunt and updating the balances
        balances[_to] = balances[_to] + _token;

        // send a soccess message to the user when all that wes needed is aproved
        emit Transfer(msg.sender, _to, afterDeduction);

        // send a soccess messge to the userr when all that wes needed is aproved
        emit Transfer(msg.sender, owner, _fee);

        return true;
    }


    function approve(address spender, uint tokens) public  returns (bool) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }


    function allowance(address tokenOwner, address spender)
    private  view returns (uint) {

        return allowed[tokenOwner][spender];
    }

    
    function transferFrom(address from, address to, uint _tokens) public  returns (bool) {

        require(msg.sender != address(0), "this address is in Valid");

        require(balances[from] >= _tokens, "You dont have alot of Token");

        require(allowed[from][msg.sender] >= _tokens, "You dont have alot of token");

        balances[from] = balances[from] - _tokens;

        allowed[from][msg.sender] = allowed[from][msg.sender] - _tokens;

        balances[to] = balances[to] + _tokens;

        emit Transfer(from, to, _tokens);

        return true;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {

        return balances[tokenOwner];
    }

    function  totalSupply() public view returns (uint256) {

        return totalSupplys;
    }

    function buyTokens(uint256 numberOfTokens) external payable {
        // keep track of number of tokens sold
        // require that a contract have enough tokens
        // require tha value sent is equal to token price
        // trigger sell event
        require(msg.value >= mul(numberOfTokens, tokenPrice));
        require(this.balanceOf(address(this)) >= numberOfTokens);
        require(this.transfer(msg.sender, numberOfTokens));

        tokensSold += numberOfTokens;
    }
   
}
