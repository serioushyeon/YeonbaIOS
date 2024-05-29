import UIKit
import SnapKit
import Tabman
import Pageboy
import Alamofire

class CollectViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    private var viewcontrollers: [UIViewController] = []
    private var tabbar = TMBar.ButtonBar().then {
        $0.backgroundView.style = .clear
        $0.layout.transitionStyle = .snap
        $0.layout.contentMode = .fit
        $0.buttons.customize { button in
            button.selectedTintColor = UIColor.primary
            button.tintColor = .gray
        }
        $0.indicator.weight = .custom(value: 3)
        $0.indicator.tintColor = UIColor.primary
    }
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setConstraints()
        tabbar.dataSource = self
        dataSource = self
        //delegate = self  // Set the delegate to self to listen for page changes
    }

    func setViewControllers() {
        let sendVC = SendCupidViewController()
        let receiveVC = RecieveCupidViewController()
        let favoriteVC = FavoriteCupidViewController()
        viewcontrollers.append(contentsOf: [sendVC, favoriteVC, receiveVC])
    }

    func setConstraints() {
        addBar(tabbar, dataSource: self, at: .custom(view: containerView, layout: nil))
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    // PageboyViewControllerDataSource methods
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewcontrollers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewcontrollers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    // TMBarDataSource method
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let titles = ["보낸화살", "즐겨찾는 이성", "받은 화살"]
        return TMBarItem(title: titles[index])
    }

    // PageboyViewControllerDelegate method
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        if let apiReloadable = viewcontrollers[index] as? APIReloadable {
            apiReloadable.reloadData()
        }
    }
}

// Protocol to be implemented by each ViewController that needs to reload data
protocol APIReloadable {
    func reloadData()
}
