import Vapor

let app = Application(.development)
app.servers.use(.http)
app.directory.publicDirectory = app.directory.workingDirectory + "../generated-site"
print(app.directory.publicDirectory)
let fileMiddleware = FileMiddleware(publicDirectory: app.directory.publicDirectory)
app.middleware.use(fileMiddleware)
try app.run()

