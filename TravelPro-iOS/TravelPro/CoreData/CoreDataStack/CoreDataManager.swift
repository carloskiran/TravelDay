import Foundation
import CoreData
class CoreDataManager {
    public class var sharedInstance : CoreDataManager {
        struct CoreDataManagerInstance {
            static let instance = CoreDataManager()
        }
        return CoreDataManagerInstance.instance
    }
    private init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: TextConstant.CoreDataKey.kContainerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK:Save conte
    func saveContext () -> Bool {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }
    // MARK:get Entity Managed Object manger addedvf
    func getEntityManagedObject(entityName: String)-> NSObject{
        let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName,
                                                in: managedContext)!
        let mo = NSManagedObject(entity: entity,
                                 insertInto: managedContext)
        return mo
    }
    // MARK:Save Or Update Entity
    func saveOrUpdateEntity() -> Bool {
            return saveContext()
    }
    // MARK: Delete Entity
    func deleteEntity<T>(entity: T){
        CoreDataManager.sharedInstance.persistentContainer.viewContext.delete((entity as? NSManagedObject)!)
        _ = saveContext()
    }
    // MARK: Fetch Entities
    func fetchEntities(fetchRequest: NSFetchRequest<NSManagedObject>)->[NSManagedObject]?{
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            let entities = try managedContext.fetch(fetchRequest)
            return entities
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: Fetch Any Entities
    func fetchAllEntities(entityName: String) -> [NSManagedObject]?{
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch any entities.
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        return fetchEntities(fetchRequest: fetchRequest)
    }
    // MARK: Delete All Data
    func deleteAllData(entity:String){
        let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let delAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entity))
        do {
            try managedContext.execute(delAllReqVar)
        }
        catch {
            print(error)
        }
    }
    
    
}
