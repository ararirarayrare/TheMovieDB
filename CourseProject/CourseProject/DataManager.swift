import Foundation
import RealmSwift

class DataManager {
    static let shared = DataManager()
    lazy var realm: Realm = {
        try! Realm()
    }()
    var data: Results<WatchLater>!
    
    func save(object: WatchLater) -> Bool {
        if let _ = getMovieBy(id: object.id) {
            return false
        } else {
            try? realm.write{
                realm.add(object, update: .modified)
            }
            return true
        }
    }
    func getMovieBy(id: Int) -> WatchLater? {
        let movie = realm.object(ofType: WatchLater.self, forPrimaryKey: id )
        return movie
    }
    func get() -> [WatchLater] {
        self.data = realm.objects(WatchLater.self)
        var array = [WatchLater]()
        for item in data {
            array.append(item)
        }
        return array
    }
    func deleteAll() {
        try! realm.write{
            realm.delete(data)
        }
    }
    func removeSelected(object: Object) {
        try! realm.write{
            realm.delete(object)
        }
    }
}
