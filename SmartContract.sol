pragma solidity ^0.4.23

// Document Timestamping & Recording Smart Contract by Pavon Dunbar

// Begin Smart Contract

contract DocumentTimestamp{
    address owner;
    
    struct Document{
        bool stored;
        uint blockNumber;
        uint blockTimestamp;
        address sender;
    }

    mapping(bytes32 => Document) internal documents;

    event DocumentEvent(uint blockNumber, bytes32 hash);

    function DocumentTimestamp() public{
        owner = msg.sender;
    }

    // In case you send funds by accident
    function empty() public{
        owner.transfer(this.balance);
    }

    function addDocument(bytes32 hash) internal{
       documents[hash].stored = true;
       documents[hash].blockNumber = block.number;
       documents[hash].blockTimestamp = block.timestamp;
       documents[hash].sender = msg.sender;
    }

    function newDocument(bytes32 hash) external returns(bool success){
        if(documents[hash].stored){
            success = false;
        }else{
            addDocument(hash);

            DocumentEvent(documents[hash].blockNumber, hash);

            success = true;
        }
        return success;
    }

    function getDocument(bytes32 hash) external view returns(uint blockNumber, uint blockTimestamp, address sender){
        require(documents[hash].stored);
        
        return(documents[hash].blockNumber, documents[hash].blockTimestamp, documents[hash].sender);
    }
}
