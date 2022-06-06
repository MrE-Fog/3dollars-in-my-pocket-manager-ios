import ReactorKit
import RxSwift
import RxCocoa

final class MyStoreInfoReactor: BaseReactor, Reactor {
    enum Action {
        case viewDidLoad
        case tapEditStoreInfo
        case tapEditIntroduction
        case tapEditMenus
        case tapEditSchedule
    }
    
    enum Mutation {
        case setStore(Store)
        case updateIntorudction(String)
        case pushEditStoreInfo(store: Store)
        case pushEditIntroduction(store: Store)
        case pushEditMenus(store: Store)
        case pushEditSchedule(store: Store)
        case showErrorAlert(Error)
    }
    
    struct State {
        var store = Store()
    }
    
    let initialState = State()
    let pushEditStoreInfoPublisher = PublishRelay<Store>()
    let pushEditIntroductionPublisher = PublishRelay<Store>()
    let pushEditMenuPublisher = PublishRelay<Store>()
    let pushEditSchedulePublisher = PublishRelay<Store>()
    private let storeService: StoreServiceType
    private let globalState: GlobalState
    
    init(
        storeService: StoreServiceType,
        globalState: GlobalState
    ) {
        self.storeService = storeService
        self.globalState = globalState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.fetchMyStore()
            
        case .tapEditStoreInfo:
            return .just(.pushEditStoreInfo(store: self.currentState.store))
            
        case .tapEditIntroduction:
            return .just(.pushEditIntroduction(store: self.currentState.store))
            
        case .tapEditMenus:
            return .just(.pushEditMenus(store: self.currentState.store))
            
        case .tapEditSchedule:
            return .just(.pushEditSchedule(store: self.currentState.store))
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge([
            mutation,
            self.globalState.updateStorePublisher
                .map { .setStore($0) }
        ])
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setStore(let store):
            newState.store = store
            
        case .updateIntorudction(let introduction):
            newState.store.introduction = introduction
            
        case .pushEditStoreInfo(let store):
            self.pushEditStoreInfoPublisher.accept(store)
            
        case .pushEditIntroduction(let store):
            self.pushEditIntroductionPublisher.accept(store)
            
        case .pushEditMenus(let store):
            self.pushEditMenuPublisher.accept(store)
            
        case .pushEditSchedule(let store):
            self.pushEditSchedulePublisher.accept(store)
            
        case .showErrorAlert(let error):
            self.showErrorAlert.accept(error)
        }
        
        return newState
    }
    
    private func fetchMyStore() -> Observable<Mutation> {
        return self.storeService.fetchMyStore()
            .map { .setStore(Store(response: $0)) }
            .catch { .just(.showErrorAlert($0)) }
    }
}
