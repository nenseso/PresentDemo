# PresentDemo

简单的说，这个问题是因为当前控制器A，要弹出控制器B，而控制器B已经被弹出或者正在被弹出的时候又调用了一次`A.present(B)`
验证代码如下：
```
    lazy var bvc: BViewController = {
        let bvc = BViewController()
        bvc.modalPresentationStyle = .fullScreen
        return bvc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func presentAction(_ sender: Any) {
        
        // situation 1：A had presented B before.
        self.present(bvc, animated: true, completion: nil)
        si1()
        
        // situation 2：A is presenting B.
        // si2()
    }
    
    func si1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.present(self.bvc, animated: true, completion: nil)
        }
    }
    
    func si2() {
        // iOS Animation duration 0.25s , so after 0.1 s,A is presenting B
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(self.bvc, animated: true, completion: nil)
        }
    }
    
```
点击按钮，我们先跑`si1()`，Xcode报错：
> Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Application tried to present modally a view controller <PresentDemo.BViewController: 0x7ff77cd09aa0> that is already being presented by <PresentDemo.ViewController: 0x7ff77e8057d0>.'

我们注释`si1()`,打开`si2()`,报错如下：
> Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Application tried to present modally a view controller <PresentDemo.BViewController: 0x7fcf005070f0> that is already being presented by <PresentDemo.ViewController: 0x7fcf00608b80>.'

修复代码如下：
```
// 在即将弹出控制器前加上校验代码，如果已经弹出，或者正在被弹出，则返回
            guard self.presentedViewController == nil else { return }
            guard self.bvc.isBeingPresented == false else { return }
```

