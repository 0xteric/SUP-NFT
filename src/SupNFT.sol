// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

contract SupNFT is ERC721Enumerable, Ownable, ReentrancyGuard {
    uint256 public immutable maxSupply;
    uint256 public immutable mintPrice;
    uint256 public immutable maxMintAmountPerTx;
    uint256 public lastId;

    event Minted(address indexed minter, uint256 amount);
    event Burned(address indexed owner, uint256 tokenId);

    constructor(
        string memory name_,
        string memory symbol_,
        uint maxSupply_,
        uint mintPrice_,
        uint maxMintAmountPerTx_
    ) ERC721(name_, symbol_) Ownable(msg.sender) {
        maxSupply = maxSupply_;
        mintPrice = mintPrice_;
        maxMintAmountPerTx = maxMintAmountPerTx_;
    }

    function mint(uint amount_) external payable {
        require(totalSupply() + amount_ <= maxSupply, "Max supply reached");
        require(
            amount_ > 0 && amount_ <= maxMintAmountPerTx,
            "Invalid mint amount"
        );

        uint cost = amount_ * mintPrice;
        require(msg.value >= cost, "Insufficient ETH");

        if (msg.value > cost) {
            (bool refund, ) = msg.sender.call{value: msg.value - cost}("");
            require(refund, "Refund failed");
        }

        for (uint i = 0; i < amount_; i++) {
            _safeMint(msg.sender, ++lastId);
        }

        emit Minted(msg.sender, amount_);
    }

    function burn(uint256 tokenId) external nonReentrant {
        require(ownerOf(tokenId) == msg.sender, "Not owner");

        _burn(tokenId);

        (bool success, ) = msg.sender.call{value: mintPrice}("");
        require(success, "Refund failed");

        emit Burned(msg.sender, tokenId);
    }

    function tokensOfOwner(
        address owner
    ) external view returns (uint256[] memory) {
        uint256 balance = balanceOf(owner);
        uint256[] memory ids = new uint256[](balance);
        for (uint256 i = 0; i < balance; i++) {
            ids[i] = tokenOfOwnerByIndex(owner, i);
        }
        return ids;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
