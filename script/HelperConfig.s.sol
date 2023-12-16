// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol"; 


contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig; 

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000E8;


    struct NetworkConfig {
        address priceFeed; 
    }

    constructor() {
        if (block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig(); 
        } else if (block.chainid == 1) {
             activeNetworkConfig = getMainnetEthConfig();
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure  returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig(
           0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return sepoliaConfig; 
    }

    function getMainnetEthConfig() public pure  returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig(
           0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        return ethConfig; 
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig; 
        }
        // 1. Deploy the mocks 
        //2. Return the mock addresses 
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS, 
            INITIAL_PRICE
        );
        vm.stopBroadcast(); 

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig; 




    }

 
}
