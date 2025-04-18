// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {Test} from "forge-std/Test.sol";

contract BaseTest is Test {
    function createArray(uint24 value1, uint24 value2, uint24 value3, uint24 value4) internal pure returns (uint24[] memory) {
        uint24[] memory array = new uint24[](4);
        array[0] = value1;
        array[1] = value2;
        array[2] = value3;
        array[3] = value4;
        return array;
    }

    function createArray(address value1) internal pure returns (address[] memory) {
        address[] memory array = new address[](1);
        array[0] = value1;
        return array;
    }

    function createArray(address value1, address value2) internal pure returns (address[] memory) {
        address[] memory array = new address[](2);
        array[0] = value1;
        array[1] = value2;
        return array;
    }

    function createArray(address value1, address value2, address value3) internal pure returns (address[] memory) {
        address[] memory array = new address[](3);
        array[0] = value1;
        array[1] = value2;
        array[2] = value3;
        return array;
    }

    function createArray(address value1, address value2, address value3, address value4) internal pure returns (address[] memory) {
        address[] memory array = new address[](4);
        array[0] = value1;
        array[1] = value2;
        array[2] = value3;
        array[3] = value4;
        return array;
    }
}