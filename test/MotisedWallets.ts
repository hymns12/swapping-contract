import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
// import { ERC20Token__factory } from "../typechain-types";
// import { ERC120Token__factory } from "../typechain-types";

describe("TokenSwap", function () {
 
  async function deployMotised() {

    const [owner, otherAccount] = await ethers.getSigners();

      const num1 = 1000000000;
      const num2 = 1000000000;

    const ERC120 = await ethers.getContractFactory("ERC120Token");
    const erc120 = await ERC120.deploy(num1, num2);

    const ERC20 = await ethers.getContractFactory("ERC20Token");
    const erc20 = await ERC20.deploy(num1, num2);

    const TokenSwap = await ethers.getContractFactory("TokenSwap");
    const tokenSwap = await TokenSwap.deploy(erc20.target, erc120.target);


    const num = 0;

    return { tokenSwap, owner, otherAccount, num, num1, num2 };
  }

  describe("Deployment", function () {
    it("chack for deployer is successful", async function () {

      const { tokenSwap, num, num1, num2 } = await loadFixture(deployMotised);

      await tokenSwap.setTokenPercentage(num);

      const reciever = await tokenSwap.getTokenPercentage();

      expect(reciever).to.be.equal(num);

    });

    it("Should set the right owner", async function () {
      const { tokenSwap, num, num1, num2 } = await loadFixture(deployMotised);

      await tokenSwap.setFeesFourTransaction(0);

      const recieverToken = await tokenSwap.getFeesFourTransaction()




      // expect(await lock.owner()).to.equal(owner.address);
    });

  //   it("Should receive and store the funds to lock", async function () {
  //     const { lock, lockedAmount } = await loadFixture(
  //       deployOneYearLockFixture
  //     );

  //     expect(await ethers.provider.getBalance(lock.target)).to.equal(
  //       lockedAmount
  //     );
  //   });

  //   it("Should fail if the unlockTime is not in the future", async function () {
  //     // We don't use the fixture here because we want a different deployment
  //     const latestTime = await time.latest();
  //     const Lock = await ethers.getContractFactory("Lock");
  //     await expect(Lock.deploy(latestTime, { value: 1 })).to.be.revertedWith(
  //       "Unlock time should be in the future"
  //     );
  //   });
  // });

  // describe("Withdrawals", function () {
  //   describe("Validations", function () {
  //     it("Should revert with the right error if called too soon", async function () {
  //       const { lock } = await loadFixture(deployOneYearLockFixture);

  //       await expect(lock.withdraw()).to.be.revertedWith(
  //         "You can't withdraw yet"
  //       );
  //     });

  //     it("Should revert with the right error if called from another account", async function () {
  //       const { lock, unlockTime, otherAccount } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       // We can increase the time in Hardhat Network
  //       await time.increaseTo(unlockTime);

  //       // We use lock.connect() to send a transaction from another account
  //       await expect(lock.connect(otherAccount).withdraw()).to.be.revertedWith(
  //         "You aren't the owner"
  //       );
  //     });

  //     it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
  //       const { lock, unlockTime } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       // Transactions are sent using the first signer by default
  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw()).not.to.be.reverted;
  //     });
  //   });

  //   describe("Events", function () {
  //     it("Should emit an event on withdrawals", async function () {
  //       const { lock, unlockTime, lockedAmount } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw())
  //         .to.emit(lock, "Withdrawal")
  //         .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
  //     });
  //   });

  //   describe("Transfers", function () {
  //     it("Should transfer the funds to the owner", async function () {
  //       const { lock, unlockTime, lockedAmount, owner } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw()).to.changeEtherBalances(
  //         [owner, lock],
  //         [lockedAmount, -lockedAmount]
  //       );
  //     });
  //   });
  });
});
