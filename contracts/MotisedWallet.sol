// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ERC20.sol";
import "./ERC120.sol";

error ADDRESS_ZERO_IS_NOT_VALID();

error SWAPING_TOKEN_MUST_BE_GREATER_THEN_ZERO();

error SENDER_DOESNT_HAVE_ENOUGH_TOKENS_TO_SEND();

error CURRENTLY_THE_EXCHANGE_DOESNT_HAVE_TOKEN120_PLEASE_RETRY_LATER();

// this contract should be deployed after the deployment of the two contracts TokenABC and TokenXYZ
// as instrcuted in the 2_deploy_contracts file
contract TokenSwap {

    // address of the deployer

    address ownerOfContract;

    //ratioAX is the percentage of how much TokenA is worth of TokenX
    uint256 percentage;

    // bool AcheaperthenX;

    uint256 feesFourTx;
    
    ERC20Token public token20;
    ERC120Token public token120;

    constructor(address _token20, address _token120) {
        ownerOfContract = msg.sender;
        token20 = ERC20Token(_token20);
        token120 = ERC120Token(_token120);

        // but in this use cae we are using this contract to transfer so its always checking the allowance of SELF

        token20.approve(address(this), token20.totalSupply());

        token120.approve(address(this), token120.totalSupply());
    }

   

    // private function that only the address of the contract can use this function
    function onlyOwnerOfContract() private view {
        payable(ownerOfContract) ==  msg.sender;
    }

    // only this contract address can set the percentage of the Token1 and  Token2s
    function setTokenPercentage(uint256 _percentage) external {
     onlyOwnerOfContract();

        percentage = _percentage;
    }

    // getting back the total percentaage of the two Token that was set
    function getTokenPercentage() external view  returns (uint256) {

     onlyOwnerOfContract();

        return percentage;
    }

    function setFeesFourTransaction(uint256 _FeesFourTx) external {

     onlyOwnerOfContract();

        feesFourTx = _FeesFourTx;
    }

    function getFeesFourTransaction() external view  returns (uint256) {

        onlyOwnerOfContract();

        return feesFourTx;
    }

    // accepts amount of token20 and exchenge it for token120, vice versa with function swapTKX
    // transfer token20 from sender to smart contract after the user has approved the smart contract to
    // withdraw amount TKA from his account, this is a better solution since it is more open and gives the
    // control to the user over what calls are transfered instead of inspecting the smart contract
    // approve the caller to transfer one time from the smart contract address to his address
    // transfer the exchanged token120 to the sender

    function swapingToken20(uint256 amountOfToken20) public returns (uint256) {
        // check if current contract has the necessary amout of Tokens to exchange
    //    require(msg.sender != address(0), "this address is not vild");

        if (msg.sender == address(0)) 
        revert ADDRESS_ZERO_IS_NOT_VALID();

        //check if amount given is not 0
        if (amountOfToken20 < 0) 
        revert SWAPING_TOKEN_MUST_BE_GREATER_THEN_ZERO();
        

        // require(amountTKA > 0, "amountTKA must be greater then zero");

        if (token20.balanceOf(msg.sender) < amountOfToken20) 
        revert SENDER_DOESNT_HAVE_ENOUGH_TOKENS_TO_SEND();

        // require(
        //     tokenABC.balanceOf(msg.sender) >= amountOfToken20,
        //     "sender doesn't have enough Tokens"
        // );

        uint256 exchangeTokens = uint256(mul(amountOfToken20, percentage));

        uint256 exchangeAmount = exchangeTokens - uint256((mul(exchangeTokens, feesFourTx)) / 100);

            if (exchangeAmount < 0)
            revert SWAPING_TOKEN_MUST_BE_GREATER_THEN_ZERO();


        // require(
        //     exchangeAmount > 0,
        //     "exchange Amount must be greater then zero"
        // );

        // if (token20.balanceOf(address(this) < exchangeAmount)) 
        // revert CURRENTLY_THE_EXCHANGE_DOESNT_HAVE_TOKEN120_PLEASE_RETRY_LATER();

        // require(
        //     token120.balanceOf(address(this)) > exchangeAmount,
        //     "currently the exchange doesnt have enough XYZ Tokens, please retry later :=("
        // );

        token20.transferFrom(msg.sender, address(this), amountOfToken20);

        token120.approve(address(msg.sender), exchangeAmount);

        token120.transferFrom(address(this), address(msg.sender), exchangeAmount);

        return exchangeAmount;
    }

    function swapingToken120(uint256 amountOfToken120) public returns (uint256) {
        //check if amount given is not 0
        // check if current contract has the necessary amout of Tokens to exchange and the sender

        if (msg.sender == address(0)) 
        revert ADDRESS_ZERO_IS_NOT_VALID();

          //check if amount given is not 0
        if (amountOfToken120 < 0) 
        revert SWAPING_TOKEN_MUST_BE_GREATER_THEN_ZERO();

        
        if (token120.balanceOf(msg.sender) < amountOfToken120) 
        revert SENDER_DOESNT_HAVE_ENOUGH_TOKENS_TO_SEND();

        // require(amountTKX >= ratioAX, "amountTKX must be greater then ratio");
        // require(
        //     tokenXYZ.balanceOf(msg.sender) >= amountTKX,
        //     "sender doesn't have enough Tokens"
        // );

        uint256 exchangeTokens = amountOfToken120 / percentage;

        uint256 exchangeAmount = exchangeTokens -  uint256(mul(exchangeTokens, feesFourTx) / 100);


        if (exchangeAmount < 0) 
         revert SWAPING_TOKEN_MUST_BE_GREATER_THEN_ZERO();

       
       
        if (token120.balanceOf(address(this)) < exchangeAmount) {
         revert CURRENTLY_THE_EXCHANGE_DOESNT_HAVE_TOKEN120_PLEASE_RETRY_LATER();
        }

       
        token120.transferFrom(msg.sender, address(this), exchangeAmount);

        token20.approve(address(msg.sender), exchangeAmount);

        token20.transferFrom(address(this), address(msg.sender), exchangeAmount);

        return exchangeAmount;
    }

    //leting the Admin of the TokenSwap to buyTokens manually is preferable and better then letting the contract
    // buy automatically tokens since contracts are immutable and in case the value of some tokens beomes
    // worthless its better to not to do any exchange at all

    // buy more Token20  for owner one or adding more
    function buyTokens20(uint256 amountOfTokne20) external payable  {

        onlyOwnerOfContract();

        token20.buyTokens{value: msg.value}(amountOfTokne20);
    }

    // buy more token120 for owner two or adding more 
    function buyTokens120(uint256 amountOfToken120) external payable {

        onlyOwnerOfContract();

        token120.buyTokens{value: msg.value}(amountOfToken120);
    }

    // calculating the percentage when ever there swap
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
}