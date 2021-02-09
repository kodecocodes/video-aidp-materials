/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public class PetAppointmentBuilderCoordinator: Coordinator {
  public let builder = PetAppointmentBuilder()
  public var children: [Coordinator] = []
  public let router: Router
  
  public init(router: Router) {
    self.router = router
  }
  
  public func present(animated: Bool, onDismissed: (() -> Void)?) {
    let viewController = SelectVisitTypeViewController.instantiate(delegate: self)
    router.present(viewController, animated: animated, onDismissed: onDismissed)
  }
}

extension PetAppointmentBuilderCoordinator: SelectVisitTypeViewControllerDelegate {
  public func selectVisitTypeViewController(_ controller: SelectVisitTypeViewController,
                                            didSelect visitType: VisitType) {
    builder.visitType = visitType
    switch visitType {
    case .well:
      presentNoAppointmentRequiredViewController()
    case .sick:
      presentSelectPainLevelViewController()
    }
  }
  
  private func presentNoAppointmentRequiredViewController() {
    let viewController = NoAppointmentRequiredViewController.instantiate(delegate: self)
    router.present(viewController, animated: true)
  }
  
  private func presentSelectPainLevelViewController() {
    let viewController = SelectPainLevelViewController.instantiate(delegate: self)
    router.present(viewController, animated: true)
  }
}

extension PetAppointmentBuilderCoordinator: NoAppointmentRequiredViewControllerDelegate {
  public func noAppointmentViewControllerDidPressOkay(_ controller: NoAppointmentRequiredViewController) {
    router.dismiss(animated: true)
  }
}

extension PetAppointmentBuilderCoordinator: SelectPainLevelViewControllerDelegate {
  public func selectPainLevelViewController(_ controller: SelectPainLevelViewController,
                                            didSelect painLevel: PainLevel) {
    builder.painLevel = painLevel
    switch painLevel {
    case .none, .little:
      presentFakingItViewController()
    case .moderate, .severe, .worstPossible:
      presentNoAppointmentRequiredViewController()
    }
  }
  
  private func presentFakingItViewController() {
    let viewController = FakingItViewController.instantiate(delegate: self)
    router.present(viewController, animated: true)
  }
}

extension PetAppointmentBuilderCoordinator: FakingItViewControllerDelegate {
  public func fakingItViewControllerPressedIsFake(_ controller: FakingItViewController) {
    router.dismiss(animated: true)
  }
  
  public func fakingItViewControllerPressedNotFake(_ controller: FakingItViewController) {
    presentNoAppointmentRequiredViewController()
  }
}
