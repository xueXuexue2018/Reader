//
//  ViewController.swift
//  Reader
//
//  Created by juntuo on 2018/11/13.
//  Copyright © 2018 juntuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataSource:[String] = []

    //当前第几页
    var currentIndex = 0
    var pageViewController : UIPageViewController!


    override func viewDidLoad() {
        super.viewDidLoad()
        let forward = UIBarButtonItem(title: "上一页", style: UIBarButtonItem.Style.plain, target: self, action: #selector(forwardAction))

        let next = UIBarButtonItem(title: "下一页", style: UIBarButtonItem.Style.plain, target: self, action: #selector(nextAction))
        self.navigationItem.rightBarButtonItems = [next, forward]

        for i in 0..<10 {
            let str = "This is the page \(i) of content displayed using UIPageViewController"
            dataSource.append(str)
        }


        let pageVC = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)

        pageViewController = pageVC
        pageVC.delegate = self
        pageVC.dataSource = self

        //得到第一页
        let cvc = viewControllerAtIndex(index: 0)
        let viewControllers = [cvc]
        pageVC .setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: nil)

        pageVC.view.frame = self.view.bounds


        self.addChild(pageVC)
        self.view.addSubview(pageVC.view)

    }
    //上一页
    @objc func forwardAction(){
        guard currentIndex > 0 else {
            return
        }
        currentIndex -= 1
        transitionWithType(type: "pageCurl", subtype: CATransitionSubtype.fromLeft.rawValue, forview: self.view)
        //控制器改变，设置显示控制器
        let cvc = viewControllerAtIndex(index: currentIndex)
        let viewControllers = [cvc]

        pageViewController.setViewControllers(viewControllers as? [UIViewController], direction:.forward, animated: false, completion: nil)


    }
    //下一页
    @objc func nextAction(){
        guard currentIndex < dataSource.count else {
            return
        }
        currentIndex += 1
        transitionWithType(type: "pageCurl", subtype: CATransitionSubtype.fromRight.rawValue, forview: self.view)

        //控制器改变，设置显示控制器
        let cvc = viewControllerAtIndex(index: currentIndex)
        let viewControllers = [cvc]

        pageViewController.setViewControllers(viewControllers as? [UIViewController], direction:.forward, animated: false, completion: nil)
    }
    //根据index得到对应的UIViewController
    private func viewControllerAtIndex(index: NSInteger)->ContentViewController?{
        if  dataSource.count == 0, index >= dataSource.count {
            return nil
        }
        //创建一个新的控制器类,并且分配给相应的数据
        let cvc = ContentViewController()
        cvc.content = dataSource[index]
        return cvc

    }
    //数组元素值，得到下标值
    private func indexOfViewController(viewController: ContentViewController)->NSInteger{

        return dataSource.index(of: viewController.content!) ?? 0
    }

    //动画实现
    /**
     *  动画效果实现
     *
     *   type    动画的类型 在开头的枚举中有列举,比如 CurlDown//下翻页,CurlUp//上翻页
     ,FlipFromLeft//左翻转,FlipFromRight//右翻转 等...
     *   subtype 动画执行的起始位置,上下左右
     *   view    哪个view执行的动画
     */
    func transitionWithType(type: String, subtype: String, forview: UIView) {
        let animation = CATransition.init()
        animation.duration = 0.7
        /**
         1、公开动画效果：
         kCATransitionFade：翻页
         kCATransitionMoveIn：弹出
         kCATransitionPush：推出
         kCATransitionReveal：移除

         2、非公开动画效果：
         “cube”：立方体
         “suckEffect”：吸收
         “oglFlip”：翻转
         “rippleEffect”：波纹
         “pageCurl”：卷页
         “cameraIrisHollowOpen”：镜头开
         “cameraIrisHollowClose”：镜头关

         3、动画方向类型：
         kCATransitionFromRight：从右侧开始实现过渡动画
         kCATransitionFromLeft：从左侧开始实现过渡动画
         kCATransitionFromTop：从顶部开始实现过渡动画
         kCATransitionFromBottom：从底部开始实现过渡动画
         **/
        //转场类型
        animation.type = CATransitionType(rawValue: type)
        //转场方向
        if subtype != nil {
            animation.subtype = CATransitionSubtype(rawValue: subtype)
        }
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        forview.layer.add(animation, forKey: "animation")
    }


}
extension ViewController:UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    //返回上一个ViewController对象
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController: viewController as! ContentViewController)
        if index == 0 || index == NSNotFound {
            return nil
        }

        index -= 1

        currentIndex = index
         transitionWithType(type: "pageCurl", subtype: CATransitionSubtype.fromRight.rawValue, forview: self.view)
        return  viewControllerAtIndex(index: index)
    }

    //返回下一个ViewController对象
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController: viewController as! ContentViewController)
        if index == NSNotFound {
            return nil
        }
        index += 1
        currentIndex = index
        if index == dataSource.count {
            return nil
        }
         transitionWithType(type: "pageCurl", subtype: CATransitionSubtype.fromRight.rawValue, forview: self.view)
        return viewControllerAtIndex(index: index)

    }

}

