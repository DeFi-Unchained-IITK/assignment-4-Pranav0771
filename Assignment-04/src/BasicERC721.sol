// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract BasicNFT is IERC721{

    string private name = "Puppy";
    string private symbol = "PUP";
    address private admin;

    constructor() {
        admin = msg.sender;
    }

    mapping(uint256 tokenId => address) private _owners;
    mapping(address owner => uint256) private _balances;
    mapping(uint256 tokenId => address) private _tokenApprovals;
    mapping(address owner => mapping(address operator => bool)) private _operatorApprovals;

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId ;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0),"_owner = Zero address");
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        require(_owners[_tokenId] != address(0),"Token does not exist");
        return _owners[_tokenId];
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable {
        _transferFrom(_from, _to, _tokenId);
        require(
            _to.code.length == 0 || IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, data) == IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable{
        _transferFrom(_from, _to, _tokenId);
        require(
            _to.code.length == 0 || IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, "") == IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
        require(_to!=address(0),"_to = Zero address");
        require(_from!=address(0),"_from = Zero address");
        require(_isApprovedOrOwner(_from, msg.sender, _tokenId),"Not Authorized");

        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        delete _tokenApprovals[_tokenId];
        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        require(_approved != address(0),"_approved = Zero address");
        address owner = _owners[_tokenId];
        require(owner == msg.sender || _operatorApprovals[owner][msg.sender],"Invalid Approver");
        _tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(_operator != address(0),"_operator = Zero address");
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address operator) {
        require(_owners[_tokenId] != address(0),"Token does not exist");
        return _tokenApprovals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return _isApprovedForAll(_owner, _operator);
    }

    function _isApprovedOrOwner(address owner, address spender, uint256 tokenId) internal view returns (bool) {
        return spender != address(0) && (spender == owner || _tokenApprovals[tokenId] == spender || _isApprovedForAll(owner, spender));
    }

    function _isApprovedForAll(address _owner, address _operator) internal view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to!=address(0),"_to = Zero address");
        require(_from!=address(0),"_from = Zero address");
        require(_isApprovedOrOwner(_from, msg.sender, _tokenId),"Not Authorized");

        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        delete _tokenApprovals[_tokenId];
        emit Transfer(_from, _to, _tokenId);
    }

    function mint(address to, uint tokenId) public {
        require(to != address(0), "ERC721: mint to the zero address");
        require(_owners[tokenId] == address(0), "ERC721: token already minted");
        require(msg.sender == admin, "ERC721: only admin can mint");
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }
}