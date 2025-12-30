// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SupNFT} from "../src/SupNFT.sol";

contract SupNFTScript is Script {
    SupNFT public supNFT;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        supNFT = new SupNFT("SupNFT", "SUP", 10000, 0.01 ether, 5);

        vm.stopBroadcast();

        console.log("SupNFT contract deployed at:", address(supNFT));
    }
}
