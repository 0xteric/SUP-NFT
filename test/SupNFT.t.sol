// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SupNFT} from "../src/SupNFT.sol";

contract SupNftTest is Test {
    SupNFT public supNFT;
    address public user = vm.addr(1);
    address public owner = vm.addr(2);

    function setUp() public {
        vm.prank(owner);
        supNFT = new SupNFT("SupNFT", "SUP", 10000, 0.01 ether, 5);
    }

    function testMint() public {
        vm.deal(user, 1 ether);
        vm.startPrank(user);

        uint amount = 5;
        uint mintPrice = supNFT.mintPrice();

        supNFT.mint{value: amount * mintPrice}(amount);

        assertEq(supNFT.totalSupply(), 5);
        assertEq(supNFT.ownerOf(1), user);
        assertEq(supNFT.ownerOf(5), user);

        vm.stopPrank();
    }
}
