# Uncomment the next line to define a global platform for your project

#source 'https://github.com/CocoaPods/Specs.git'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

 platform :ios, '15.0'

target 'YXBShelfProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_modular_headers!
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'R.swift'
  
  #加载框, Toast, TODO: 封装一层Toast调用
  pod 'Toast-Swift'
  #swift版Masonry
  pod 'SnapKit'
  pod 'SwifterSwift'
  pod 'Moya'
  pod 'HandyJSON'
  pod 'SDWebImage'
  pod 'Kingfisher'

  #pod 'MJRefresh'
  #pod 'SVProgressHUD'
  pod 'MBProgressHUD'


# 本地源码依赖库
def loaclPods
# 配置环境，测试下的
  #pod 'DBDebugToolkit', :configurations => ['Debug'], :path => './LocalPods/DBDebugToolkit'
  #pod 'DBDebugToolkit', :configurations => ['Debug']
end

loaclPods()


# MARK: - 下面是为了示例代码导入的，按需
# 个性装扮
def MyDress
  # JXCategoryView 的 swift 版本
  pod 'JXSegmentedView'
end

# vap特效
def VAP
  pod 'QGVAPlayer'
end

# 聊天的tableview
def TextMessage
  pod 'YYText'
end

# 分页，下拉
def Page
  pod 'MJRefresh'
end

#banner
def Banner
  pod 'FSPagerView'
end

# 图片预览库，蜂巢开源的
def Preview
  pod 'JXPhotoBrowser'
end

# 下载
def DownLoad
  # 下载资源的库。这个呢怎么说
  pod 'Tiercel'
end

# 为了示例所需要的,按需导入
def example
  MyDress()
  VAP()
  TextMessage()
  Page()
  Banner()
  Preview()
  DownLoad()
end
example()

end
