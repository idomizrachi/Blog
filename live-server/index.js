var liveServer = require("live-server");
var configuration = {
    port: 9090,
    host: "0.0.0.0",
    root: "../build",
    file: "index.html",
};

liveServer.start(configuration);
