# 挂机工厂大亨 Beta

一个使用 Godot 4.6 制作的轻量挂机工厂经营游戏原型。

玩家从起步小作坊开始，通过自动生产、点击收益、雇佣工人、升级工厂、解锁新工厂、完成成就目标和换地区来不断扩大工厂帝国。

## 主要功能

- 主菜单、工厂主界面、设置弹层、离线收益弹层、成就目标弹层。
- 6 个工厂：起步小作坊、木材加工厂、食品加工厂、钢铁冶炼厂、电子制造厂、机器人装配厂。
- 每个工厂有独立背景图、产能、工人数量、工人等级和工厂等级。
- 自动收益、点击空白界面获得金币、点击收益升级。
- 离线收益开关、离线效率升级、离线上限升级。
- 成就目标系统，包含金币、产能、工人、解锁、升级、点击、离线、换地区等目标。
- 换地区系统：解锁全部工厂后可重开地区，升级条件提高，收益倍率提高。
- 设置支持窗口大小、音效音量、背景音乐音量、离线收益开关、中英文切换、删除存档。
- 背景音乐循环播放，按钮和点击金币都有音效。
- 作弊模式：游戏内按 `G` 打开。
- 自动保存和离线结算。

## 运行方式

1. 安装 Godot `4.6.2` 或兼容的 Godot 4.6 版本。
2. 用 Godot 打开本目录中的 `project.godot`。
3. 运行主场景：`res://scenes/main.tscn`。

命令行检查脚本：

```sh
/path/to/Godot --headless --path . --check-only --script res://scripts/main.gd
```

## 导出

项目已包含 `export_presets.cfg`，当前预设：

- `macOS`
- `Windows Desktop`

导出需要安装 Godot 4.6.2 export templates。

示例：

```sh
/path/to/Godot --headless --path . --export-release macOS build/IdleFactoryTycoon_Beta_macOS.zip
/path/to/Godot --headless --path . --export-release "Windows Desktop" build/IdleFactoryTycoon_Beta_windows_x64.exe
```

## 目录结构

- `project.godot`：Godot 项目配置。
- `scenes/main.tscn`：主场景。
- `scripts/main.gd`：主要游戏逻辑、UI、存档、音频和数值系统。
- `art/`：游戏美术资源，包括图标、Logo、背景、UI 面板和装饰素材。
- `tools/remove_chroma_key.gd`：用于把纯色背景图片转成透明 PNG 的项目工具脚本。
- `export_presets.cfg`：导出配置。

## 发布说明

macOS 版本如果未做 Apple notarization，用户首次下载运行时可能需要在系统设置里手动允许打开。
