# BatchMintContract
This is a batch mint tool to interact with contract directly by contract.
The reasons why we choose contract interaction is 
1. batch mint can be held in one txn
2. save intilized gas
3. learn something new?

#batchMint.sol
This is main contract to interact with target contract. It's only a toy tool rn.
There are some TODOs here.
1. Add factory mode to mint more than once
2. Add adjustable gas in call function
3. Add more secure funciont to guard it.
Disclaimer: it's risky to use it directly. Please make sure you review it and understand every details in the code. Make your own change. It's not investement advise.

#kopoko.sol
This is the example target contract we are using.

#ERC721A
This is a lib.