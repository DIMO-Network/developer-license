// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import {IERC165} from "./IERC165.sol";
// import {IERC5727} from "./IERC5727.sol";

// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

// /** 
//  *
//  */
// contract DimoDevLicense is IERC165, IERC5727, Ownable2Step {
//     //event MetadataUpdate(uint256 _tokenId);  
//     //event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
//     //event Locked(uint256 tokenId);
//     //event Unlocked(uint256 tokenId);
//     //event Issued (address indexed from, address indexed to, uint256 indexed tokenId, BurnAuth burnAuth);
//     //event Revoked(address indexed from, uint256 indexed tokenId);
//     //event Verified(address indexed by, uint256 indexed tokenId, bool result);

//     constructor() Ownable(msg.sender) {

//     }

//     function verify(
//         uint256 tokenId,
//         bytes calldata data
//     ) external returns (bool){}

//     function revoke(
//         uint256 tokenId,
//         uint256 amount,
//         bytes calldata data
//     ) external payable {}

//     function revoke(uint256 tokenId, bytes calldata data) external payable {}
    
//     function issue(
//         uint256 tokenId,
//         uint256 amount,
//         bytes calldata data
//     ) external payable {}

//     function issue(
//         address to,
//         uint256 tokenId,
//         uint256 slot,
//         IERC5727.BurnAuth auth,
//         address verifier,
//         bytes calldata data
//     ) external payable {}

//     function issuerOf(uint256 tokenId) external view returns (address) {}
    
//     function verifierOf(uint256 tokenId) external view returns (address) {}

//     function burnAuth(uint256 tokenId) external view returns (IERC5727.BurnAuth) {}

//     function locked(uint256 tokenId) external view returns (bool) {}

//     function supportsInterface(bytes4 interfaceID) external view returns (bool) {}


// //Hey team, couple of API related questions: 
// //(1) How would one developer get the client_id? Through DIMO support or is this something that needs to be configured on DIMO engineering?
// //(2) For the redirect_uri, it sounds like it needs to be whitelisted by DIMO on our backend, is that correct?
// //Today, it’s a yaml file in GitHub. Need your GitHub handle.
// // *
// //By putting the redirect Uris in a smart contract, anyone can then validate this is a real developer
// // *
// //
// //Okay.
// //There is a bunch of things still not decided, like will our frontend do the wallet connection etc, 
// //or if we should redirect to your page which then does the wallet connection etc.
// //Okay, well if we can do the login flow by standard oauth and then get a token back that we can use to 
// //fetch data from your system, that would be pretty nice.
// //That’s the goal. You shouldn’t need to proxy requests through your backend.
// //Lemme know what redirect URI you need. We can add localhost stuff on dev, that’s no problem
// //
// //Oookay two-step auth. More unspeakable things done to OAuth https://github.com/DIMO-Network/dex#ethereum-login
// //Eh I'm gonna change that field name that's an embarrassment
// //Can you rename redirect uri to domain? 
// //And then check domain==redirect uri

// }
