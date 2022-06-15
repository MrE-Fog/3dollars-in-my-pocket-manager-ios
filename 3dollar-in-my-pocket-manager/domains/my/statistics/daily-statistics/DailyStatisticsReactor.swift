import Foundation

import ReactorKit
import Base
import RxRelay

final class DailyStatisticsReactor: BaseReactor, Reactor {
    enum Action {
        case viewDidLoad
        case refresh
        case viewWillAppear
        case willDisplayCell(index: Int)
    }
    
    enum Mutation {
        case clearStatisticGroups
        case appendStatisticGroups([StatisticGroup])
        case updateTableViewHeight([StatisticGroup])
        case showErrorAlert(Error)
    }
    
    struct State {
        var statisticGroups: [StatisticGroup]
    }
    
    let initialState: State
    let updateTableViewHeightPublisher = PublishRelay<[StatisticGroup]>()
    private let feedbackService: FeedbackServiceType
    private let userDefaults: UserDefaultsUtils
    private var endDate: Date? = Date()
    private var startDate = Date().addWeek(week: -1)
    
    init(
        feedbackService: FeedbackServiceType,
        userDefaults: UserDefaultsUtils,
        state: State = State(statisticGroups: [])
    ) {
        self.feedbackService = feedbackService
        self.userDefaults = userDefaults
        self.initialState = state
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return self.fetchStatistics(startDate: self.startDate, endDate: self.endDate)
            
        case .refresh:
            return .concat([
                .just(.clearStatisticGroups),
                self.fetchStatistics(startDate: self.startDate, endDate: self.endDate)
            ])
            
        case .viewWillAppear:
            return .just(.updateTableViewHeight(self.currentState.statisticGroups))
            
        case .willDisplayCell(let index):
            guard index >= self.currentState.statisticGroups.count - 1 else { return .empty() }
            
            return self.fetchStatistics(startDate: self.startDate, endDate: self.endDate)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .clearStatisticGroups:
            newState.statisticGroups = []
            
        case .appendStatisticGroups(let statisticGroup):
            newState.statisticGroups.append(contentsOf: statisticGroup)
            
        case .updateTableViewHeight(let statisticGroups):
            self.updateTableViewHeightPublisher.accept(statisticGroups)
            
        case .showErrorAlert(let error):
            self.showErrorAlert.accept(error)
        }
        
        return newState
    }
    
    private func fetchStatistics(
        startDate: Date,
        endDate: Date?
    ) -> Observable<Mutation> {
        guard let endDate = endDate else { return .empty() }
        let storeId = self.userDefaults.storeId
        
        return self.feedbackService.fetchDailyStatistics(
            storeId: storeId,
            startDate: startDate,
            endDate: endDate
        )
        .do(onNext: { [weak self] response in
            guard let self = self else { return }
            if let nextCursor = response.cursor.nextCursor {
                let endDate = DateUtils.toDate(dateString: nextCursor, format: "yyyy-MM-dd")
                
                self.endDate = endDate
                self.startDate = endDate.addWeek(week: -1)
            } else {
                self.endDate = nil
            }
        })
        .map { .appendStatisticGroups($0.contents.map(StatisticGroup.init(response:))) }
        .catch { .just(.showErrorAlert($0)) }
    }
}
