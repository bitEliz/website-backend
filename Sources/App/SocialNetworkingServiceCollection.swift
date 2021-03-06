import Vapor

/// In progress
/// admin user request.
class SocialNetworkingServiceCollection: ApiCollection {
    typealias T = SocialNetworkingService

    var path: String = SocialNetworking.schema + "/services"

    func performUpdate(_ original: T?, on req: Request) throws -> EventLoopFuture<T.DTO> {
        let coding = try req.content.decode(T.DTO.self)
        
        var upgrade = T.init()

        if let original = original {
            upgrade = try original.update(with: coding)
        } else {
            upgrade = try T.init(from: coding)
            upgrade.id = nil
        }

        return upgrade.save(on: req.db)
            .flatMapThrowing({
                try upgrade.dataTransferObject()
            })
    }
}
