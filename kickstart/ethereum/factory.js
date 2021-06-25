import web3 from "./web3";
import CampaignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  "0xF411425147a998C3579C108cC539b12ff3FBBd3b"
);

export default instance;
