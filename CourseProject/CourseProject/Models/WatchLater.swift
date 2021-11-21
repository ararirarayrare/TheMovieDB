import Foundation
import RealmSwift

class WatchLater: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var numberOfSeasons = 0
    @objc dynamic var posterPath: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var releaseDate: String = ""
}
