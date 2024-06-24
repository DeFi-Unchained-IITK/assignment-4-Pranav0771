// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol"; 
import "../src/BasicERC721.sol"; 

contract BasicERC721Test is Test{
    BasicNFT public basicERC721;

    function setUp() public {
        basicERC721 = new BasicNFT();
    }

    function testBalanceOf() public {
        basicERC721.mint(address(this), 1);
        assertEq(basicERC721.balanceOf(address(this)), 1);
    }

    function testOwnerOf() public {
        basicERC721.mint(address(this), 1);
        assertEq(basicERC721.ownerOf(1), address(this));
    }

    function testTransferFrom() public {
        basicERC721.mint(address(this), 1);
        basicERC721.transferFrom(address(this), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);
        assertEq(basicERC721.balanceOf(address(this)), 0);
        assertEq(basicERC721.balanceOf(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906)), 1);
        assertEq(basicERC721.ownerOf(1), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906));
    }

    function testSafeTransferFrom() public {
        basicERC721.mint(address(this), 1);
        basicERC721.safeTransferFrom(address(this), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);
        assertEq(basicERC721.balanceOf(address(this)), 0);
        assertEq(basicERC721.balanceOf(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906)), 1);
        assertEq(basicERC721.ownerOf(1), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906));
    }

    function testSafeTransferFromWithBytes() public {
        basicERC721.mint(address(this), 1);
        basicERC721.safeTransferFrom(address(this), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1, "0x");
        assertEq(basicERC721.balanceOf(address(this)), 0);
        assertEq(basicERC721.balanceOf(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906)), 1);
        assertEq(basicERC721.ownerOf(1), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906));
    }

    function testIsApprovedForAll() public {
        basicERC721.mint(address(this), 1);
        basicERC721.setApprovalForAll(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), true);
        assertEq(basicERC721.isApprovedForAll(address(this), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906)), true);
    }

    function testSetApprovalForAll() public {
        basicERC721.mint(address(this), 1);
        basicERC721.setApprovalForAll(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), true);
        assertEq(basicERC721.isApprovedForAll(address(this), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906)), true);
    }

    function testSetApprovalForAllWithZeroAddress() public {
        vm.expectRevert("_operator = Zero address");
        basicERC721.setApprovalForAll(address(0), true);
    }

    function testApprove() public {
        basicERC721.mint(address(this), 1);
        basicERC721.approve(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);
        assertEq(basicERC721.getApproved(1), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906));
    }

    function testGetApproved() public {
        basicERC721.mint(address(this), 1);
        basicERC721.approve(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);
        assertEq(basicERC721.getApproved(1), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906));
    }

    function testGetApprovedWithNonExistentToken() public {
        vm.expectRevert("Token does not exist");
        basicERC721.getApproved(1);
    }

    function testApproveWithZeroAddress() public {
        basicERC721.mint(address(this), 1);
        vm.expectRevert("_approved = Zero address");
        basicERC721.approve(address(0), 1);
    }
    
    function testApproveWithNonApprovedAddress() public {
        basicERC721.mint(address(this), 1);
        vm.expectRevert("Invalid Approver");
        vm.prank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
        basicERC721.approve(address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);
    }

    function testTransferFromWithZeroAddress() public {
        basicERC721.mint(address(this), 1);
        vm.expectRevert("_from = Zero address");
        basicERC721.transferFrom(address(0), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);

        vm.expectRevert("_to = Zero address");
        basicERC721.transferFrom(address(this), address(0), 1);
    }

    function testTransferFromWithNonApprovedAddress() public {
        basicERC721.mint(address(this), 1);
        vm.expectRevert("Not Authorized");
        vm.prank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
        basicERC721.transferFrom(address(this), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);
    }

    function testOwnerOfWithNonExistentToken() public {
        vm.expectRevert("Token does not exist");
        basicERC721.ownerOf(1);
    }

    function testBalanceOfWithZeroAddress() public {
        vm.expectRevert("_owner = Zero address");
        basicERC721.balanceOf(address(0));
    }

    function testSafeTransferFromWithZeroAddress() public {
        basicERC721.mint(address(this), 1);
        vm.expectRevert("_from = Zero address");
        basicERC721.safeTransferFrom(address(0), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);

        vm.expectRevert("_to = Zero address");
        basicERC721.safeTransferFrom(address(this), address(0), 1);
    }

    function testSafeTransferFromWithNonApprovedAddress() public {
        basicERC721.mint(address(this), 1);
        vm.expectRevert("Not Authorized");
        vm.prank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
        basicERC721.safeTransferFrom(address(this), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1);
    }

    function testSafeTransferFromWithZeroAddressAndBytes() public {
        basicERC721.mint(address(this), 1);
        vm.expectRevert("_from = Zero address");
        basicERC721.safeTransferFrom(address(0), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1, "0x");

        vm.expectRevert("_to = Zero address");
        basicERC721.safeTransferFrom(address(this), address(0), 1, "0x");
    }

     function testSafeTransferFromWithNonApprovedAddressAndBytes() public {
        basicERC721.mint(address(this), 1);
        vm.expectRevert("Not Authorized");
        vm.prank(0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc);
        basicERC721.safeTransferFrom(address(this), address(0x90F79bf6EB2c4f870365E785982E1f101E93b906), 1, "0x");
    }

}