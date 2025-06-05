// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NaiveReceiverLenderPool.sol";
import "./FlashLoanReceiver.sol";

// echidna . --contract NaiveReceiverEchidna --config contracts/naive-receiver/config.yaml
contract NaiveReceiverEchidna {
    NaiveReceiverLenderPool public pool;
    FlashLoanReceiver public receiver;

    uint256 public constant POOL_INITIAL_BALANCE = 1_000 ether;
    uint256 public constant RECEIVER_INITIAL_BALANCE = 10 ether;
    
    constructor() payable {
        pool = new NaiveReceiverLenderPool();
        receiver = new FlashLoanReceiver(payable(address(pool)));

        // Initial Setup
        payable(address(pool)).transfer(POOL_INITIAL_BALANCE);
        payable(address(receiver)).transfer(RECEIVER_INITIAL_BALANCE);
    }

    // Add random function to see if it calls them in any order
    function random() public view returns (uint256) {
        return pool.fixedFee();
    }
    function recieverPoolBalance() public view returns (uint256) {
        return address(receiver).balance;
    }

    // Fuzz Test.
    function flashLoan(uint256 amount) public {
        pool.flashLoan(address(receiver), amount);
    }

    function echidna_pool_balance_never_decreases() public view returns (bool) {
        return address(pool).balance >= POOL_INITIAL_BALANCE;
    }

    function echidna_receiver_balance_never_decreases() public view returns (bool) {
        return address(receiver).balance >= RECEIVER_INITIAL_BALANCE;
    }
}