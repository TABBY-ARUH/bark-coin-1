// barkcoin.mo

module {
  // Define a type for user accounts
  public type Account = {
    owner : Principal;
    balance : Nat;
  };

  // Define a type for transfer results
  public type TransferResult = {
    success : Bool;
    message : Text;
  };

  // Define a type for Bark Coin smart contract
  public type BarkCoin = {
    // Map user principal to their account
    accounts : [var Account]; // Make accounts mutable
  };

  // Initialize Bark Coin with an empty list of accounts
  public func init() : async BarkCoin {
    return { accounts = [] };
  };

  // Function to transfer Bark Coins from one account to another
  public func transfer(sender : Principal, recipient : Principal, amount : Nat) : async TransferResult {
    // Find sender's account
    let senderIndex = findAccountIndex(sender);
    assert(senderIndex != null, "Sender account not found");

    // Find recipient's account
    let recipientIndex = findAccountIndex(recipient);
    assert(recipientIndex != null, "Recipient account not found");

    // Check if sender has enough balance
    if (BarkCoin.accounts[senderIndex].balance >= amount) {
      // Deduct amount from sender's balance
      BarkCoin.accounts[senderIndex].balance -= amount;

      // Add amount to recipient's balance
      BarkCoin.accounts[recipientIndex].balance += amount;

      return { success = true; message = "Transfer successful" };
    } else {
      return { success = false; message = "Insufficient balance" };
    };
  };

  // Function to get the balance of a user's account
  public func getBalance(owner : Principal) : async Nat {
    // Find the account of the owner
    let index = findAccountIndex(owner);
    assert(index != null, "Account not found");

    return BarkCoin.accounts[index].balance;
  };

  // Helper function to find account index by owner principal
  private func findAccountIndex(owner : Principal) : ?Nat {
    // Loop through accounts to find the index of the account
    let len = Array.length(BarkCoin.accounts);
    for (i in 0 .. len) {
      if (BarkCoin.accounts[i].owner == owner) {
        return ?i;
      };
    };
    return ?null; // Account not found
  };
};
