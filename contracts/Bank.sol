// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;


import "hardhat/console.sol";

contract Bank {
    
    struct Account {
        string name;
        address accountNumber;
        uint256 balance;
        bool exists;
    }

    
    mapping(address => Account) private accounts;
    
    address[] private accountAddresses;
    
    event AccountCreated(address indexed owner, address indexed accountNumber, string name);
    event Deposit(address indexed owner, address indexed accountNumber, uint256 amount);
    event Withdrawal(address indexed owner, address indexed accountNumber, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    error accountValidationError();

    
    function createAccount(string memory name) public {
        require(!accounts[msg.sender].exists, "Account already exists");
        accounts[msg.sender] = Account(name, msg.sender, 0, true);
        accountAddresses.push(msg.sender);


        emit AccountCreated(msg.sender, msg.sender, name);
    }
    
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount cannot be zero");
        require(accounts[msg.sender].exists, "Account does not exist");
        accounts[msg.sender].balance += msg.value;
        emit Deposit(msg.sender, msg.sender, msg.value);
    }

    
    function withdraw(uint256 amount) public {
        require(accounts[msg.sender].exists, "Account does not exist");
        require(accounts[msg.sender].balance >= amount, "Insufficient balance");
        accounts[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, msg.sender, amount);
    }

    
    function transfer(address to, uint256 amount) public {
        require(accounts[msg.sender].exists, "Sender account does not exist");
        require(accounts[to].exists, "Recipient account does not exist");
        require(accounts[msg.sender].balance >= amount, "Insufficient balance");
        accounts[msg.sender].balance -= amount;
        accounts[to].balance += amount;
        emit Transfer(msg.sender, to, amount);
    }

    
    function getBalance() public view returns (uint256) {
        require(accounts[msg.sender].exists, "Account does not exist");
        return accounts[msg.sender].balance;
    }

    
    function getAccountDetails() public view returns (string memory, address, uint256) {
        require(accounts[msg.sender].exists, "Account does not exist");
        Account storage account = accounts[msg.sender];
        return (account.name, account.accountNumber, account.balance);
    }


    function getAccountDetailsByAddress(address accountAddress) public view returns (string memory, address, uint256) {
        require(accounts[accountAddress].exists, "Account does not exist");
        Account storage account = accounts[accountAddress];
        return (account.name, account.accountNumber, account.balance);
    }


    function getAllAccounts() public view returns (Account[] memory) {
        uint256 totalAccounts = accountAddresses.length;
        Account[] memory allAccounts = new Account[](totalAccounts);
        
        for (uint256 i = 0; i < totalAccounts; i++) {
            allAccounts[i] = accounts[accountAddresses[i]];
        }
        
        return allAccounts;
    }
}