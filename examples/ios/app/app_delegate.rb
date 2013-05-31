class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @controller = UIViewController.alloc.initWithNibName(nil, bundle:nil)
    @window.rootViewController = @controller
    @window.makeKeyAndVisible

    label = UILabel.new
    label.text = "App Icon should be stamped: Close me and see!"
    label.sizeToFit
    label.center = @controller.view.frame.center
    @controller.view.addSubview(label)
    true
  end
end
