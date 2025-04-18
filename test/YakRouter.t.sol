// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {BaseTest} from "./BaseTest.sol";
import {YakRouter, Trade, FormattedOffer} from "../src/contracts/YakRouter.sol";
import {UniswapV3Adapter} from "../src/contracts/adapters/UniswapV3Adapter.sol";
import {UniswapV2Adapter} from "../src/contracts/adapters/UniswapV2Adapter.sol";
import {IERC20} from "../src/contracts/interface/IERC20.sol";

contract YakRouterTest is BaseTest {
    YakRouter public router;
    UniswapV3Adapter public uniswapV3Adapter;
    UniswapV2Adapter public honeyswapAdapter;

    address public WETH = 0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1;
    address public wXDAI = 0xe91D153E0b41518A2Ce8Dd3D7944Fa863463a97d;
    address public USDCe = 0x2a22f9c3b484c3629090FeED35F17Ff8F88f76F0;
    address public USDC = 0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83;

    address public admin = makeAddr("admin");

    function setUp() public {
        vm.createSelectFork("https://rpc.gnosischain.com");

        router = new YakRouter(
            admin,
            admin
        );

    
        uniswapV3Adapter = new UniswapV3Adapter(
            admin,
            "UniswapV3Adapter",
            500_000,
            500_000,
            0x8Dde3C180480ae01279B66a761fDaabBBc09d841,
            0xe32F7dD7e3f098D518ff19A22d5f028e076489B1,
            createArray(100, 500, 3000, 10000)
        );

        honeyswapAdapter = new UniswapV2Adapter(
            admin,
            "HoneyswapAdapter",
            0xA818b4F111Ccac7AA31D0BCc0806d64F2E0737D7,
            3,
            120_000
        );
    }

    function testUpdateFeeClaimerAsAdmin() public {
        address bob = makeAddr("bob");

        vm.prank(admin);
        router.setFeeClaimer(bob);

        assertEq(router.FEE_CLAIMER(), bob, "Fee claimer should be updated to bob");
    }

    function testUpdateFeeClaimerAsUser() public {
        address bob = makeAddr("bob");

        vm.expectRevert("Maintainable: Caller is not a maintainer");
        router.setFeeClaimer(bob);

        assertEq(router.FEE_CLAIMER(), admin, "Fee claimer should not be updated");
    }

    function testSwap() public {
        FormattedOffer memory offer = router.findBestPath(
            createArray(address(uniswapV3Adapter), address(honeyswapAdapter)),
            createArray(WETH, wXDAI, USDCe, USDC),
            100e18,
            wXDAI,
            WETH,
            4
        );

        Trade memory trade = Trade({
            amountIn: 100e18,
            amountOut: (offer.amounts[offer.amounts.length - 1]) * 95 / 100,
            path: offer.path,
            adapters: offer.adapters
        });


        router.swapNoSplitFromNATIVE{ value: 100e18 }(wXDAI, trade, address(this), 0);

        uint256 balance = IERC20(WETH).balanceOf(address(this));

        assertGt(balance, 0, "Balance should be greater than 0");
    }
}
