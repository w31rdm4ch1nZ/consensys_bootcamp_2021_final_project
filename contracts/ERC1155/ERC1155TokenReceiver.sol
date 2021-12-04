pragma solidity ^0.8.0;
import "./IERC1155TokenReceiver.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract ERC1155TokenReceiver is ERC165, IERC1155TokenReceiver {
    constructor() public {
        _registerInterface(
            ERC1155TokenReceiver(0).onERC1155Received.selector ^
            ERC1155TokenReceiver(0).onERC1155BatchReceived.selector
        );
    }
}
