const { network } = require("hardhat")

function sleep(timeInMs) {
    return new Promise((resolve) => setTimeout(resolve, timeInMs))
}

//we can actually mannually mine (using evm_mine RPC method)nodes and move blocks ahead, so that moralis svr knows that the tx is confirmed 
async function moveBlocks(amount, sleepAmount = 0) { //sleep amt --> seconds b/w each blocks
    console.log("Moving blocks...")
    for (let index = 0; index < amount; index++) {
        await network.provider.request({
            method: "evm_mine", //this is similar to raffle, this is actually the same way we make the raw call to BC nodes
            params: [],
        })
        if (sleepAmount) {
            console.log(`Sleeping for ${sleepAmount}`)
            await sleep(sleepAmount)
        }
    }
    console.log(`Moved ${amount} blocks`)
}

module.exports = {
    moveBlocks,
    sleep,
}
