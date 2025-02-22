// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/Maintainable.sol";

contract DummyMaintainable is Maintainable {
    constructor(address _admin) Maintainable(_admin) {
    }

    function onlyMaintainerFunction() public onlyMaintainer {}
}
