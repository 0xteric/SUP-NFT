// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SupNFT} from "../src/SupNFT.sol";

contract SupNftTest is Test {
    SupNFT public supNFT;
    address public owner = vm.addr(33);
    address public user = vm.addr(1);

    function setUp() public {
        vm.prank(owner);
        supNFT = new SupNFT("SupNFT", "SUP", 10000, 0.01 ether, 5);
    }

    function testMint() public {
        vm.deal(user, 1 ether);
        vm.startPrank(user);

        uint amount = 5;
        uint mintPrice = supNFT.mintPrice();
        uint userBalanceBefore = user.balance;
        uint supBalanceBefore = address(supNFT).balance;

        supNFT.mint{value: amount * mintPrice}(amount);

        uint userBalanceAfter = user.balance;
        uint supBalanceAfter = address(supNFT).balance;

        assertTrue(userBalanceBefore > userBalanceAfter);
        assertEq(supBalanceBefore, supBalanceAfter - amount * mintPrice);
        assertEq(supNFT.totalSupply(), 5);
        assertEq(supNFT.ownerOf(1), user);
        assertEq(supNFT.ownerOf(5), user);

        vm.stopPrank();
    }

    function testBurn() public {
        vm.deal(user, 1 ether);
        vm.startPrank(user);

        uint amountToMint = 2;
        uint amountToBurn = 1;

        uint mintPrice = supNFT.mintPrice();
        uint userBalanceBefore = user.balance;

        supNFT.mint{value: amountToMint * mintPrice}(amountToMint);

        uint userBalanceMiddle = user.balance;

        supNFT.burn(amountToBurn);

        uint userBalanceAfter = user.balance;

        assertEq(
            userBalanceBefore,
            userBalanceMiddle + amountToMint * mintPrice
        );
        assertEq(
            userBalanceAfter,
            userBalanceMiddle + amountToBurn * mintPrice
        );
    }
}
