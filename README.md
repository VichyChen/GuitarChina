## 吉他中国 iOS 客户端
吉他中国 GuitarChina 是[吉他中国论坛](https://bbs.guitarchina.com/forum.php)的 iOS 客户端。

其中，吉他中国Pro 是无广告收费版。

## AppStore


[吉他中国](https://itunes.apple.com/cn/app/ji-ta-zhong-guo/id1089161305?mt=8)

 <img src="http://ow8x4rvvt.bkt.clouddn.com/%E5%90%89%E4%BB%96%E4%B8%AD%E5%9B%BD%E4%B8%8B%E8%BD%BD%E5%9C%B0%E5%9D%80.png" width = "200" height = "200" alt="吉他中国Pro" align=center />

[吉他中国Pro](https://itunes.apple.com/cn/app/ji-ta-zhong-guo-pro/id1193034315?mt=8)

 <img src="http://ow8x4rvvt.bkt.clouddn.com/%E5%90%89%E4%BB%96%E4%B8%AD%E5%9B%BDPro%E4%B8%8B%E8%BD%BD%E5%9C%B0%E5%9D%80.png" width = "200" height = "200" alt="吉他中国Pro" align=center />


## 项目描述
### 主要功能
- 首页热帖
- 论坛板块
- 新闻
- 帖子展示，收藏、分享
- 回复、发帖
- 用户模块

### 数据来源
部分API通过原先的官方APP抓包分析获得，个别页面通过抓取网页（[首页](https://bbs.guitarchina.com/forum.php?mod=guide&view=hot)、[新闻](https://news.guitarchina.com/?cat=1)、[个人资料](https://bbs.guitarchina.com/space-uid-1627015.html)），XPath 解析数据获得。

### 技术难点
帖子详情页的展示。由于 API 数据每个帖子的回复都是返回 HTML，由于 iOS 列表页面的高度计算是一个大问题，这种场景下（html+列表）用原生似乎难以实现。尝试过几种方案，后面通过 UIWebview 拼接加载 HTML 完成。

### 运行
```
1、git clone https://github.com/VichyChen/GuitarChina-iOS-APP.git
```

```
2、cd根目录，open GuitarChina.xcworkspace，command+r
```
