import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const Bank = buildModule("Bank", (m) => {


  const bank = m.contract("Bank");

  return { bank };
});

export default Bank;
