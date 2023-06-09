import RxSwift
import RxCocoa

class BaseReactor {
    let showErrorAlert = PublishRelay<Error>()
    let showLoadginPublisher = PublishRelay<Bool>()
}
