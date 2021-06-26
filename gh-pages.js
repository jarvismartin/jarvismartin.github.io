const ghpages = require("gh-pages");

ghpages.publish(
  "public", // path to public directory
  {
    branch: "gh-pages",
    repo: "https://github.com/jarvismartin/jarvismartin.github.io.git", // Update to point to your repository
    user: {
      name: "Jarvis Martin", // update to use your name
      email: "jarvism@protonmail.com", // Update to use your email
    },
  },
  () => {
    console.log("Deploy Complete!");
  }
);
