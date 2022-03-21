import json
from hashlib import sha256

from eth_account.messages import encode_defunct
from hexbytes import HexBytes
from web3 import Web3

w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:7545"))

private_key = "0x1903a3639d3b25dfe99cfe1dccf4bc6370a9a3ec669f8af5104da8a3136d021c"
account = w3.eth.account.privateKeyToAccount(private_key)

with open("../build/contracts/IssuersContract.json", "r") as f:
    abi = json.load(f)["abi"]

idType = "0x9d069a3c410c4441a92b5d4e5e1ea9ca"
contract_addr = "0xb4ec0AB3d885EC2B0b716F01a0162c815d6f39eB"
issuer_contract = w3.eth.contract(contract_addr, abi=abi)
transaction = issuer_contract.functions.addIdType(
    HexBytes(idType)
).buildTransaction(
    {
        "gas": 70000,
        "gasPrice": w3.toWei(10, "gwei"),
        "from": account.address,
        "nonce": w3.eth.get_transaction_count(account.address),
    }
)
signed = account.sign_transaction(transaction)
res = w3.eth.send_raw_transaction(signed.rawTransaction)

# Next, test message signing and verification
message = HexBytes(sha256("test".encode("utf-8")).hexdigest()).hex()
sig = account.sign_message(encode_defunct(hexstr=message)).signature.hex()
res = issuer_contract.functions.verifySignature(
    HexBytes(message), HexBytes(sig), HexBytes(idType)
).call()
print(res)
# transaction = issuer_contract.functions.verifyIdType(
#     HexBytes(message), HexBytes(sig), HexBytes(idType)
# ).buildTransaction(
#     {
#         "gas": 70000,
#         "gasPrice": w3.toWei(10, "gwei"),
#         "from": account.address,
#         "nonce": w3.eth.get_transaction_count(account.address),
#     }
# )
# res = w3.eth.send_raw_transaction(account.sign_transaction(transaction).rawTransaction)
# print(res.hex())
