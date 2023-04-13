## 部分效果展示

![网易云音乐.gif](https://cdn.nlark.com/yuque/0/2023/gif/27222704/1681373940432-30118fcb-9b83-442d-b6f9-627c54f6f58a.gif#averageHue=%23cd987b&clientId=uc27c9835-07ee-4&from=paste&height=664&id=ue65df901&name=%E7%BD%91%E6%98%93%E4%BA%91%E9%9F%B3%E4%B9%90.gif&originHeight=830&originWidth=1362&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=1981286&status=done&style=none&taskId=u85382fb7-28b1-40b7-b594-236af694f7c&title=&width=1089.6)

## 实现的功能

视频相关：播放暂停、播放进度调节、音量调节、列表显示指定目录下的视频文件
音频相关：播放暂停、上一曲下一曲、随机播放和顺序播放、播放进度调节、歌词滚动以及高亮、列表显示指定目录下的音频文件
其他功能：支持皮肤切换、窗口最大化最小化、窗口任意形状调节、窗口移动、边框阴影

## 主窗口总体布局

![音视频播放器.drawio.svg](https://cdn.nlark.com/yuque/0/2023/svg/27222704/1681366138507-b38fe3cd-f33e-47b2-9ec2-1323030f8432.svg#clientId=uc27c9835-07ee-4&from=paste&height=632&id=u4b211c40&name=%E9%9F%B3%E8%A7%86%E9%A2%91%E6%92%AD%E6%94%BE%E5%99%A8.drawio.svg&originHeight=790&originWidth=1226&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=208475&status=done&style=none&taskId=ua03a33ee-6af7-4602-9475-d47371792e7&title=&width=980.8)

## 主要文件描述

| 目录          | 文件名              | 说明                                                         | 界面展示                                                     |
| ------------- | ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| MyMusic       | MusicPanel.qml      | 只要是和音乐相关的所有控件都放在此文件中作为汇总，控件包括：顶部的选择目录按钮和搜索框、音乐列表、控制音乐播放的相关控件（MusicControlBar.qml） |                                                              |
|               | MusicTable.qml      | 实现音乐列表（包括表头和表项目）                             |                                                              |
|               | MusicControlBar.qml | 控制音乐播放的相关控件，包括进度条、播放、上一曲等按钮       | ![image.png](https://cdn.nlark.com/yuque/0/2023/png/27222704/1681366718197-318187e3-cc28-429c-a7e1-797296d4676d.png#averageHue=%23f8dcdb&clientId=uc27c9835-07ee-4&from=paste&height=15&id=u3192bc4e&name=image.png&originHeight=93&originWidth=807&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=16757&status=done&style=none&taskId=ue4e9c25e-0b0b-49c5-a90f-d793183db38&title=&width=128) |
|               | LyricsPanel.qml     | 歌词页面，左侧放图像，右侧放歌词                             | ![image.png](https://cdn.nlark.com/yuque/0/2023/png/27222704/1681366817066-e1b7d69f-e2f4-42b2-896b-5eedcffb3937.png#averageHue=%23f1b6b5&clientId=uc27c9835-07ee-4&from=paste&height=612&id=u219a5b9f&name=image.png&originHeight=765&originWidth=1225&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=96138&status=done&style=none&taskId=uc916a31f-871d-4927-81aa-70b237c06bf&title=&width=980) |
| MyVideo       | VideoPanel.qml      | 放所有与视频相关的控件，一共两个页面，用stackview管理，第一个页面是搜索框和视频列表，第二个页面是播放视频的控件 |                                                              |
|               | VideoFirstPage.qml  | 放置顶部搜索框以及视频列表，即管理Common.ContentHeader.qml和VideoTable.qml |                                                              |
|               | VideoTable.qml      | 展示视频列表，包括表头和表项                                 | ![image.png](https://cdn.nlark.com/yuque/0/2023/png/27222704/1681367029619-7aeb4cb5-7fe6-45b2-b64f-f5bc128de1c8.png#averageHue=%23fbecec&clientId=uc27c9835-07ee-4&from=paste&height=233&id=u9da45ea9&name=image.png&originHeight=291&originWidth=783&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=32401&status=done&style=none&taskId=u1a934fa0-1ce9-4d46-9013-03e74211578&title=&width=626.4) |
|               | VideoSecondPage.qml | 顶部返回按钮和标题的显示、播放视频的控件                     | ![image.png](https://cdn.nlark.com/yuque/0/2023/png/27222704/1681367378363-3430df8c-289b-4e54-9650-89ee2980cacf.png#averageHue=%23ebb1b1&clientId=uc27c9835-07ee-4&from=paste&height=612&id=u385661a6&name=image.png&originHeight=765&originWidth=1225&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=268073&status=done&style=none&taskId=u0f1632cd-41d7-4cff-be5d-2c550d5e6ee&title=&width=980) |
|               | VideoControlBar.qml | 控制视频播放、显示播放进度、音量等                           | ![image.png](https://cdn.nlark.com/yuque/0/2023/png/27222704/1681367473217-a47ed1fc-de0c-4e16-ab91-dbaaed85056c.png#averageHue=%23c2c1bb&clientId=uc27c9835-07ee-4&from=paste&height=373&id=u8e0ead87&name=image.png&originHeight=466&originWidth=806&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=211817&status=done&style=none&taskId=ua3cbd46b-6e02-4ccf-a3d4-9bb7423947d&title=&width=644.8) |
| 根目录qml文件 | LeftNavigation.qml  | 左侧导航栏，共有三个选项：视频播放、音频播放、基础设置       |                                                              |
|               | Content.qml         | 左侧导航栏所有具体内容都放在这里，用StackLayout实现不同内容的切换 |                                                              |
| 根目录cpp文件 | musicplayer.h       | 所有关于音频的逻辑实现都在这里（比如选择音频目录、更新音乐表格的内容，歌词的读取与歌词模型的更新），注册了许多函数供QML调用，管理MusicTableModel（歌曲列表模型），LyricModel（歌词模型） |                                                              |
|               | videoplayer.h       | 所有关于视频的逻辑实现都在这里（比如选择视频目录、更新视频表格的内容），注册了许多函数供QML调用 |                                                              |
|               | musictablemodel.h   | 音乐列表模型，为音乐列表提供数据，具有添加删除数据的功能     |                                                              |
|               | videotablemodel.h   | 视频列表模型，为视频列表提供数据，具有添加删除数据的功能     |                                                              |
|               | lyricmodel.h        | 歌词列表模型，通过QStringList存储歌词                        |                                                              |

## 视频播放

### 实现思路

视频列表通过TableView实现，其代理（delegate）要显示的数据来自videoplayer.h的`m_videoTableModel`，当双击列表某一行时，触发VideoTable.qml中自定义的信号`doubleClicked(int row)`，该信号将页面切换到VideoSecondPage.qml（播放视频的页面），同时把双击的行号传给VideoSecondPage.qml，这样VideoSecondPage.qml就可以根据行号调用C++函数获取当前双击行对应的视频路径，因此就可以实现视频的播放

```javascript
// 切换页面并传递行号 VideoPanel.qml
VideoFirstPage {
  onTableRowDoubleClicked: {  // 其实就是VideoTable.qml的doubleClicked信号
    root.selectedRow = row  // 将选中的行号赋值给root.selectedRow便于传入到secondPage中
    stackView.push(secondPage)   // 跳转到第二个页面(播放视频的页面)
  }
}

// 视频播放器 VideoSecondPage.qml
VideoPlayer {
  id: videoPlayer
  anchors.left: parent.left
  anchors.right: parent.right
  height: width * 9 / 16
  source: myVideoPlayer.getVideoPathByRow(root.selectedRow)
}
```

## 音频播放

### 实现思路

播放音频实现：音频列表通过TableView实现，其代理（delegate）要显示的数据来自musicplayer.h的`m_musicTableModel`，当双击列表某一行时，触发MusicTable.qml中自定义的信号`doubleClicked(int row)`，该信号把双击的行号传给MusicControlBar.qml（控制音频播放等页面），这样MusicControlBar.qml就可以根据行号调用C++函数获取当前双击行对应的视频路径，因此就可以实现视频的播放
上一曲/下一曲实现：MusicControlBar.qml有上一曲下一曲按钮，实现切歌只需要改变MusicControlBar.qml的`seclectedRow`属性即可，`seclectedRow`记录当前播放的音乐在列表的哪一行。当点击下一曲后，将`seclectedRow`增加1即可，不需要其他操作，因为`MediaPlayer`（位于MusicControlBar.qml中）的`source`属性是和`seclectedRow`是相互绑定的，只要`seclectedRow`改变，`MediaPlayer`的`source`也会相应改变，而`source`的改变又会触发`onSourceChanged`信号，`onSourceChanged`实现了音频的播放，主要代码如下：

```javascript
// 下一曲按钮
CusWidgets.ImageButton {
    ...省略代码一万行
    onClicked: {
        if (root.playMode === root.order) {// 如果是顺序播放
            if (root.seclectedRow !== -1) {
                if (root.seclectedRow === myMusicPlayer.musicTableModel.rowCount()-1) {
                    root.seclectedRow = 0
                } else {
                    root.seclectedRow += 1
                }
            } else {
                root.seclectedRow = 0
            }
        } else { // 如果是随机播放
            root.seclectedRow = getRandomNum(0, myMusicPlayer.musicTableModel.rowCount())
        }
    }
}

MediaPlayer {
    id: musicPlayer
    source: root.seclectedRow === -1 ? "" : myMusicPlayer.getMusicPathByRow(root.seclectedRow)
    onSourceChanged: {
        musicPlayer.play()
    }
}
```

歌词显示实现：
（1）歌词模型的更新：前面说到，切歌只需要改变MusicControlBar.qml自定义的`seclectedRow`属性即可，当`seclectedRow`改变后，其触发的信号就可以实现对歌词模型的更新

```javascript
MusicControlBar { // 位于MusicPanel.qml
    id: musicControlBar
    onSeclectedRowChanged: {
        myMusicPlayer.upDateLyricModelBy(seclectedRow) //调用C++函数来更新歌词信息
    }
}
```

（2）歌词滚动实现：
LRC歌词文件如下：

```javascript
// 第一个数字表示分钟，第二个数字表示秒，第三个数字可能是毫秒
// 不过我们只用到前两个数字和歌词内容
[0:0.250.00]沉默是金 - 张国荣
[0:1.500.00]词：许冠杰
[0:2.190.00]曲：张国荣
[0:27.450.00]夜风凛凛 独回望旧事前尘
[0:33.120.00]是以往的我充满怒愤

// 另一种lrc歌词文件格式是下面这样的
// 第一个数字是分钟，第二个数字是秒，第三个数字是多少个10毫秒，也就是说，
// 第三个数最大为100
[ver:v1.0]     // 我的程序为了方便没有解析这些信息
[ti:家]			
[00:00.36]家 - 许巍 
[00:01.04]词：许巍
[00:01.69]曲：许巍
[00:37.95]拥抱着亲人的时候
```

了解歌词格式后，可以通过正则表达式解析歌词（见lyrics.h的`parseLyrics`函数），该函数把歌词的时间戳（比如`[0:27.450.00]`）和歌词对应的索引（索引标记着这是第几句歌词，比如`[0:27.450.00]`对应的索引为3，索引从0开始）存储到QMap，即下面代码的`m_lyric2IdxMap`中，时间戳是键，索引是值，然后把歌词内容（比如：`[0:27.450.00]`对应歌词：夜风凛凛 独回望旧事前尘）存储到歌词模型`LyricModel`中，`LyricModel`其实就是对`QStringList`进行管理。歌词解析完成后，接下来就是实现歌词滚动，如下面代码所示，我们可以在`MediaPlayer`的`onPositionChanged`信号处理中，获取当前应该显示歌词的索引号，获取索引的思路是根据当前音乐播放进度（即形参`qint64 pos`的值），遍历上述`m_lyric2IdxMap`，找到`pos`在那个歌词的时间段内，然后返回该歌词在`LyricModel`的索引。

```javascript
MediaPlayer {      
    onPositionChanged: {
        // 实时显示歌词 调用c++函数，返回此时应该显示的歌词的索引
        var idx = myMusicPlayer.getLyricIdxByPosition(position)
        if (idx === -1) {
            root.lyricIdx = -1   // -1表示当前position没有合适的歌词
        } else {
            root.lyricIdx = idx
        }
    }
}

// c++函数，见musicplayer.cpp
int MusicPlayer::getLyricIdxByPosition(qint64 pos)
{
     QMap<qint64, int>::iterator iter = m_lyric2IdxMap.begin();
     while (iter != m_lyric2IdxMap.end())
     {
         if ((iter.key()-500<=pos)  && (iter+1).key()-500 > pos)
         {
             return iter.value();
         }
         iter++;
     }
     return -1;
}
```

根据播放进度获得当前歌词索引后，只需要吧该歌词索引值赋值给显示歌词的`ListView`的`currentIndex`属性即可

```javascript
ListView {
  id: lyricsList
  currentIndex: lyricIndex===-1?currentIndex:lyricIndex
  // 省略代码一万行
}
```

## BUG

点击左侧导航栏的音频播放，然后最大化窗口，点击左侧视频播放，发现视频表格并没有随着窗口宽度变化而发生变化，不知道为什么，明明已经再TableView的`onWidthChangede`中调用了`forceLayout()`。如果解决了请告知一声

```javascript
TableView {
    id: tableView
    // 省略代码
    columnWidthProvider: function(colum) { return root.columnWidths[colum] }
    onWidthChanged: {
        // If you change the values that a rowHeightProvider or a columnWidthProvider
        // return for rows and columns inside the viewport, you must call forceLayout.
        // This informs TableView that it needs to use the provider functions again to
        // recalculate and update the layout.
        forceLayout()
    }
}
```

## 参考资料

皮肤切换实现：
解析歌词：；
歌词显示：
窗口宽高调整：





