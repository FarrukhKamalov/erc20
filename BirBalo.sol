// SPDX-License-Identifier: MIT

import "./ERC20.sol";

contract BirBalo is ERC20 {
    constructor(address shop) ERC20("BirBalo", "BRB", 20, shop) {}
}


contract MShop {
    IERC20 public token;
    address payable public owner;
    event Bought(uint _amount, address indexed _buyer);
    event Sold(uint _amount, address indexed _seller);

    constructor(){
        token = new BirBalo(address(this));
        owner = payable(msg.sender);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "not an owner");
        _;
    }

    function sell(uint _amountToSell) external  {
        require(_amountToSell > 0 && token.balanceOf(msg.sender) >= _amountToSell, "incorrect mount");

        uint allowance =  token.allowance(msg.sender, address(this));
        require(allowance >= _amountToSell, "check allowance");

        token.transferFrom(msg.sender, address(this), _amountToSell);

        payable(msg.sender).transfer(_amountToSell);

        emit Sold(_amountToSell, msg.sender);
    }


    receive()  external  payable { 
        uint tokensToBuy = msg.value;
        require(tokensToBuy > 0, "Not enough funds!");

   
        require(tokenBalance() >= tokensToBuy, "not enough tokens!");

        token.transfer(msg.sender, tokensToBuy);
        emit Bought(tokensToBuy, msg.sender); 
    }

    function tokenBalance() public view returns(uint) {
        return token.balanceOf(address(this));
    }

}