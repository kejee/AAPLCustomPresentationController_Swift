//
//  AAPLCustomPresentationController_Swift.swift
//  Apple
//
//  Created by HYapple on 2024/4/11.
//

import UIKit

class AAPLCustomPresentationController_Swift: UIPresentationController, UIViewControllerAnimatedTransitioning {
    
    let CORNER_RADIUS: CGFloat = 1.0
    
    var dimmingView: UIView?
    var presentationWrappingView: UIView?

    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var initialTranslationY: CGFloat = 0
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
        //添加下滑退出手势
        setupPanGestureRecognizer()
    }
    

    
    override var presentedView: UIView? {
        return presentationWrappingView
    }
    
    override func presentationTransitionWillBegin() {
///        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        let presentedViewControllerView = super.presentedView!
        
        let presentationWrapperView = UIView(frame: frameOfPresentedViewInContainerView)
//        presentationWrapperView.layer.shadowPath = UIBezierPath(rect: presentationWrapperView.bounds).cgPath
        presentationWrapperView.layer.shadowOpacity = 0.44
        presentationWrapperView.layer.shadowRadius = 13.0
        presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6.0)
        presentationWrappingView = presentationWrapperView
        
        let presentationRoundedCornerView = UIView(frame: presentationWrapperView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -CORNER_RADIUS, right: 0)))
        presentationRoundedCornerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentationRoundedCornerView.layer.cornerRadius = CORNER_RADIUS
        presentationRoundedCornerView.layer.masksToBounds = true
        
        let presentedViewControllerWrapperView = UIView(frame: presentationRoundedCornerView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: CORNER_RADIUS, right: 0)))
        presentedViewControllerWrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        presentedViewControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds
        presentedViewControllerWrapperView.addSubview(presentedViewControllerView)
        
        presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
        presentationWrapperView.addSubview(presentationRoundedCornerView)
        
        dimmingView = UIView(frame: containerView.bounds)
        dimmingView?.backgroundColor = UIColor.black
        dimmingView?.alpha = 0.0
        dimmingView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmingView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:))))
        containerView.addSubview(dimmingView!)
        
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            dimmingView?.alpha = 0.4
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmingView?.alpha = 0.4
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard !completed else { return }
        presentationWrappingView = nil
        dimmingView = nil
    }
    
    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else { return }
        
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmingView?.alpha = 0.0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }
        presentationWrappingView = nil
        dimmingView = nil
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container === presentedViewController {
            containerView?.setNeedsLayout()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container === presentedViewController {
            return presentedViewController.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        var presentedViewControllerFrame = containerView.bounds
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        
        presentedViewControllerFrame.size.height = presentedViewContentSize.height
        presentedViewControllerFrame.origin.y = containerView.bounds.maxY - presentedViewContentSize.height
        presentedViewControllerFrame.size.width = presentedViewContentSize.width
        presentedViewControllerFrame.origin.x = (containerView.bounds.width - presentedViewContentSize.width) / 2
        
        return presentedViewControllerFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView?.frame = containerView?.bounds ?? .zero
        presentationWrappingView?.frame = frameOfPresentedViewInContainerView
    }
    
    @objc func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionContext?.isAnimated ?? false ? 0.2 : 0.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
 
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
//        let finalFrame = transitionContext.finalFrame(for: toViewController)
//        
//        if toViewController.isBeingPresented {
//            containerView.addSubview(toViewController.view)
//            toViewController.view.frame = finalFrame
//            toViewController.view.transform = CGAffineTransform(translationX: 0, y: finalFrame.height)
//            
//            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//                toViewController.view.transform = .identity
//            }, completion: { _ in
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            })
//        } else {
//            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//                fromViewController.view.transform = CGAffineTransform(translationX: 0, y: finalFrame.height)
//            }, completion: { _ in
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            })
//        }
//        
//        return
        
        
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        
        let isPresenting = fromViewController == presentingViewController
        
        var toViewInitialFrame = transitionContext.initialFrame(for: toViewController)
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
        
        if let toView = toView {
            containerView.addSubview(toView)
        }
        
        if isPresenting {
            let containerViewBounds = containerView.bounds
            let toViewContentSize = toViewFinalFrame.size
            toViewInitialFrame.origin = CGPoint(x: (containerViewBounds.width - toViewContentSize.width) / 2, y: containerViewBounds.maxY)
            toViewInitialFrame.size = toViewFinalFrame.size
            if let toView = toView {
                toView.frame = toViewInitialFrame
            }
        } else {
//            fromViewFinalFrame = fromView!.frame.offsetBy(dx: 0, dy: fromView!.frame.height)
            if let fromView = fromView {
                fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame))
            }
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if isPresenting {
                if let toView = toView {
                    toView.frame = toViewFinalFrame
                }
            } else {
                if let fromView = fromView {
                    fromView.frame = fromViewFinalFrame
                }
                
            }
        }, completion: { finished in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
    }
}

extension AAPLCustomPresentationController_Swift: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension AAPLCustomPresentationController_Swift {
    private func setupPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.panGestureRecognizer = panGesture
        presentedViewController.view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: presentedViewController.view)
        
        switch gesture.state {
        case .began:
            initialTranslationY = translation.y
        case .changed:
            let offset = translation.y - initialTranslationY
            presentedViewController.view.frame.origin.y = max(0, offset)
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: presentedViewController.view)
            if velocity.y > 0 || presentedViewController.view.frame.origin.y > presentedViewController.view.frame.height / 2 {
                dismissPresentedViewController()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.presentedViewController.view.frame.origin.y = 0
                }
            }
        default:
            break
        }
    }
    private func dismissPresentedViewController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}


/*
 let vc = MYViewController()

 let presentationController = AAPLCustomPresentationController(presentedViewController: vc, presenting: parent)
 vc.transitioningDelegate = presentationController

 parent.present(vc, animated: true, completion: nil)
 
 //--
 extension MYViewController {
     override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
         super.willTransition(to: newCollection, with: coordinator)
         
         updatePreferredContentSizeWithTraitCollection(newCollection)
     }
     
     
     func updatePreferredContentSizeWithTraitCollection(_ newCollection: UITraitCollection) {
         let w = getScreenWidth()
         let h = getScreenHeight()
         self.preferredContentSize = CGSize(width: w, height: h*0.7)
     }
 }
 
 */
/*
 func updatePreferredContentSize(with traitCollection: UITraitCollection) {
     let sW = UIScreen.main.bounds.size.width
     let sH = UIScreen.main.bounds.size.height
     print("\(self.view.bounds.size.width), \(sW), \(sH)")
     // 解决横屏到竖屏的 bug
     let w: CGFloat = traitCollection.verticalSizeClass == .compact ? (self.contentWidth.constant + 40) : (sW > sH ? sH : sW)
     
     let top: CGFloat = traitCollection.verticalSizeClass == .compact ? 20 : 44
     let h: CGFloat = 240 + edgeValue().top + 10 + top
     self.preferredContentSize = CGSize(width: w, height: h)
 }

 */
