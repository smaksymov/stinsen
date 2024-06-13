import Foundation
import SwiftUI

/// The NavigationViewCoordinator is used to represent a coordinator with a NavigationView
public class NavigationViewCoordinator<T: NavigationCoordinatable>: ViewWrapperCoordinator<T, AnyView> {
    public init(_ childCoordinator: T) {
        super.init(childCoordinator) { view in
            #if os(macOS)
            AnyView(
                NavigationView {
                    view
                }
            )
            #else
            if #available(iOS 16.0, *) {
                AnyView(
                    StinsenNavigationStack(path: $path) {
                        view
                    }
                        .navigationViewStyle(.automatic)
                )
            } else {
                AnyView(
                    NavigationView {
                        view
                    }
                    .navigationViewStyle(.stack)
                )
            }
            #endif
        }
        if #available(iOS 16.0, *) {
            childCoordinator.stack.$value
                .map { result -> [Int] in
                    Array(result.indices)
                }
                .sink { [weak self] result in
                    self?.path = result
                }
                .store(in: &bag)
        }
    }
    
    @available(*, unavailable)
    public override init(_ childCoordinator: T, _ view: @escaping (AnyView) -> AnyView) {
        fatalError("view cannot be customized")
    }
    
    @available(*, unavailable)
    public override init(_ childCoordinator: T, _ view: @escaping (any Coordinatable) -> (AnyView) -> AnyView) {
        fatalError("view cannot be customized")
    }
}
