// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721A.sol";

contract Deployed is ReentrancyGuard {
    function saleMint(uint256 _ammount) external payable nonReentrant {}

    function revealed() public pure returns (bool) {}

    function priceSale() public pure returns (uint256) {}
}

contract contractMint is ReentrancyGuard, IERC721Receiver, Ownable {
    Deployed dc;

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes memory _data
    ) public override returns (bytes4) {
        return 0x150b7a02;
    }

    function existing(address _t) external onlyOwner {
        dc = Deployed(_t);
    }

    // TODO: renounceOwnership

    function getStatus() public view returns (bool result) {
        return dc.revealed();
    }

    function getPrice() public view returns (uint256 result) {
        return dc.priceSale();
    }

    function mint(uint256 _val) external payable onlyOwner nonReentrant {
        dc.saleMint{value: _val * getPrice()}(_val);
    }

    function mint(address _e, uint256 _val) external payable onlyOwner {
        (bool success, ) = _e.call{value: _val * getPrice()}(
            abi.encodePacked(bytes4(keccak256("saleMint(uint256)")), _val)
        ); // D's storage is set, E is not modified
        require(success);
    }

    function withdrawMoney() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function withdrawNFT(address _e, uint256 id)
        external
        nonReentrant
        onlyOwner
    {
        ERC721A token = ERC721A(_e);
        require(token.balanceOf(address(this)) > 0, "Caller must own nft");
        require(token.ownerOf(id) == address(this), "You must own the token");

        token.transferFrom(address(this), msg.sender, id);
        // TODO: (bool success, ) = _e.call(abi.encodePacked(bytes4(keccak256("transferFrom(address,address,uint256)")), address(this), msg.sender,id));
        // require(success, "Transfer failed.");
    }
}
