import fs from "node:fs/promises";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const outputPath = "/Users/pixeltrace/Desktop/挂机工厂大亨_美术素材任务与AI提示词.xlsx";

const workbook = Workbook.create();

function applyHeaderStyle(range) {
  range.format = {
    fill: "#1F4E78",
    font: { name: "Arial", size: 11, color: "#FFFFFF", bold: true },
    horizontalAlignment: "center",
    verticalAlignment: "center",
    wrapText: true,
    borders: { preset: "all", style: "thin", color: "#B7C9D6" },
  };
}

function applyBodyStyle(range) {
  range.format = {
    font: { name: "Arial", size: 10, color: "#1F2933" },
    verticalAlignment: "top",
    wrapText: true,
    borders: { preset: "all", style: "thin", color: "#D9E2EC" },
  };
}

function styleTitle(range) {
  range.format = {
    fill: "#0B1F33",
    font: { name: "Arial", size: 18, color: "#FFFFFF", bold: true },
    horizontalAlignment: "center",
    verticalAlignment: "center",
  };
}

function setWidths(sheet, widths) {
  widths.forEach((width, index) => {
    const col = String.fromCharCode("A".charCodeAt(0) + index);
    sheet.getRange(`${col}:${col}`).format.columnWidthPx = width;
  });
}

const overviewRows = [
  ["项目", "挂机工厂大亨 测试版"],
  ["目标", "将当前程序 UI 原型替换为统一的工厂题材美术风格，并补齐 AI 可生成素材。"],
  ["内部 UI 分辨率", "固定 1280×720，所有界面素材需优先保证该画幅完整显示。"],
  ["建议风格", "明亮、精致、轻度卡通的经营模拟游戏风格；工业主题但不要阴暗脏乱。"],
  ["第一批优先", "主菜单背景、游戏 Logo、工厂主界面背景、6 个工厂图标、金币图标、按钮和面板皮肤。"],
  ["第二批优先", "工人图标、升级/雇佣图标、离线收益插图、删除存档确认弹窗、金币动画和解锁特效。"],
  ["AI 生成注意", "多数 UI 图标请要求透明背景、无文字、居中、边缘干净；背景图可以生成完整画面。"],
];

const tasks = [
  ["A001", "P0", "品牌/全局", "应用图标", "用于 Godot 项目图标和桌面图标", "1024×1024，正方形", "工厂建筑 + 金币 + 齿轮，清晰轮廓", "生成一个正方形游戏应用图标，主题是挂机工厂经营游戏。画面中心是一座可爱的现代小工厂，带烟囱、齿轮和金币元素，明亮精致，轻度卡通，边缘干净，高辨识度，适合作为手机和桌面游戏图标，无文字。", "不要文字，不要真实照片，不要过度复杂背景，不要暗黑恐怖风，不要低清晰度。", "PNG / SVG", "icon_factory_tycoon_1024.png", "待制作"],
  ["A002", "P0", "品牌/全局", "游戏标题 Logo", "主菜单标题替换文字标题", "建议 900×260，透明背景", "中文标题字形 + 工业装饰", "设计一张中文游戏标题 Logo，文字为“挂机工厂大亨”，风格明亮、精致、轻度卡通，字形厚实有经营游戏感，加入齿轮、金币、工厂烟囱等小装饰，透明背景，适合放在主菜单顶部。", "不要英文，不要额外文字，不要复杂背景，不要金属过暗，不要文字变形难读。", "PNG 透明背景", "logo_idle_factory_cn.png", "待制作"],
  ["A003", "P0", "主菜单", "主菜单背景", "进入游戏界面大背景", "1280×720，16:9", "明亮工厂园区远景", "生成一张 16:9 游戏主菜单背景，画面是明亮的工厂园区，有可爱的厂房、传送带、远处烟囱、金币和柔和阳光，经营模拟游戏风格，色彩清爽，中心上方留出标题 Logo 区域，中间留出按钮区域，不能有文字。", "不要文字，不要黑暗污染风，不要真实照片，不要人物特写，不要过多杂乱细节。", "PNG", "bg_main_menu_1280x720.png", "待制作"],
  ["A004", "P1", "主菜单", "主菜单装饰前景", "按钮区和标题周围装饰", "1280×720 或分层透明 PNG", "金币、齿轮、管道、轻动画元素", "生成一组透明背景的主菜单装饰元素，包括金币、齿轮、管道、小烟囱、工厂招牌，轻度卡通经营游戏风格，边缘干净，可拆分成多个 UI 装饰图层，无文字。", "不要文字，不要复杂背景，不要写实污渍，不要低清。", "PNG 透明背景", "decor_main_menu_factory_set.png", "待制作"],
  ["A005", "P0", "工厂主界面", "工厂界面背景", "进入工厂后的主背景", "1280×720，16:9", "可扩张的厂房内部/外部", "生成一张 16:9 工厂经营游戏主界面背景，画面展示整洁明亮的工厂车间和生产线，有机器、传送带、箱子、远处厂房结构，留出左侧列表面板和右侧详情面板的空间，整体不要太抢眼，无文字。", "不要文字，不要暗黑赛博风，不要真实照片，不要凌乱危险工地，不要人物过多。", "PNG", "bg_factory_screen_1280x720.png", "待制作"],
  ["A006", "P0", "UI组件", "通用面板皮肤", "用于工厂列表、详情、目标、设置弹层", "九宫格切片，建议源图 256×256", "浅深对比、工业边框、低圆角", "设计一套经营游戏 UI 面板皮肤，轻度工业主题，深蓝灰底色，金属边框，细微铆钉和齿轮装饰，适合九宫格切片，边缘清晰，低圆角，不包含文字。", "不要文字，不要过度花哨，不要圆角过大，不要纯紫色渐变，不要脏污。", "PNG 透明边缘 / 9-slice", "ui_panel_industrial_9slice.png", "待制作"],
  ["A007", "P0", "UI组件", "主要按钮皮肤", "进入工厂、雇佣、升级等主要操作", "九宫格切片，建议 320×96", "金色/蓝色高亮按钮", "设计一个经营游戏主要按钮皮肤，适合“进入工厂、雇佣、升级”等操作，明亮金色或蓝色，轻度工业金属质感，低圆角，留出文字区域，包含普通状态、悬停状态、按下状态三种，无文字。", "不要文字，不要过亮荧光，不要复杂图案，不要巨大圆角。", "PNG 透明背景 / 3状态", "ui_button_primary_states.png", "待制作"],
  ["A008", "P0", "UI组件", "危险按钮皮肤", "删除存档按钮", "九宫格切片，建议 320×96", "红色警示但不恐怖", "设计一个游戏危险操作按钮皮肤，用于删除存档，红色警示风格，轻度工业主题，边缘清晰，低圆角，包含普通、悬停、按下三种状态，无文字。", "不要文字，不要血腥，不要恐怖，不要过度尖锐。", "PNG 透明背景 / 3状态", "ui_button_danger_states.png", "待制作"],
  ["A009", "P1", "UI组件", "禁用按钮皮肤", "金币不足时按钮禁用", "九宫格切片，建议 320×96", "灰蓝色低饱和", "设计一个游戏禁用按钮皮肤，灰蓝色低饱和，工业金属感，适合金币不足时显示，低圆角，无文字，边缘干净。", "不要文字，不要亮色，不要透明度太低导致看不见。", "PNG 透明背景", "ui_button_disabled.png", "待制作"],
  ["A010", "P1", "UI组件", "进度条皮肤", "下一个工厂解锁进度", "横向条，建议 800×48", "金币能量填充", "设计一套横向进度条 UI，工业经营游戏风格，外框为金属边，内部填充为金币金色能量条，包含空条和满条两层，透明背景，无文字。", "不要文字，不要竖向设计，不要过度发光，不要复杂背景。", "PNG 透明背景 / 分层", "ui_progress_unlock_bar.png", "待制作"],
  ["A011", "P1", "UI组件", "下拉框皮肤", "窗口大小选项", "九宫格切片，建议 360×72", "简洁面板风", "设计一个游戏设置界面下拉框皮肤，深蓝灰工业风，右侧有小箭头区域，低圆角，适合显示窗口大小选项，无文字。", "不要文字，不要网页风，不要过度装饰。", "PNG 透明背景", "ui_dropdown_window_size.png", "待制作"],
  ["A012", "P1", "UI组件", "音量滑杆皮肤", "音效音量调节", "横向滑杆，建议 520×64", "机械旋钮/能量轨道", "设计一个游戏音量滑杆 UI，横向轨道，工业机械风格，滑块像小齿轮或圆形旋钮，轨道有蓝色能量填充，透明背景，无文字。", "不要文字，不要真实照片，不要复杂背景。", "PNG 透明背景 / 轨道+滑块", "ui_slider_volume.png", "待制作"],
  ["A013", "P0", "货币/资源", "金币图标", "顶部金币栏、收益文本、奖励弹窗", "256×256，透明背景", "圆润金币，清晰轮廓", "生成一个透明背景金币图标，适合休闲经营游戏，金色圆币，带轻微高光和工厂齿轮压印，居中，边缘清晰，图标风格，不能有文字。", "不要文字，不要真实硬币照片，不要背景，不要过度复杂纹理。", "PNG 透明背景", "icon_coin.png", "待制作"],
  ["A014", "P1", "货币/资源", "每秒收益图标", "总产能/每秒收益旁边", "256×256，透明背景", "金币 + 秒表/箭头", "生成一个透明背景图标，表示每秒收益，元素包括金币、向上箭头和小秒表，轻度卡通经营游戏风格，清晰易读，无文字。", "不要文字，不要复杂背景，不要写实。", "PNG 透明背景", "icon_income_per_second.png", "待制作"],
  ["A015", "P1", "货币/资源", "离线收益图标", "离线收益弹窗", "256×256，透明背景", "月亮 + 工厂 + 金币", "生成一个透明背景图标，表示离线收益，元素包括夜晚小月亮、工厂和金币，温暖可爱，经营模拟游戏风格，无文字。", "不要文字，不要阴森夜景，不要复杂背景。", "PNG 透明背景", "icon_offline_earnings.png", "待制作"],
  ["A016", "P0", "工厂图标", "起步小作坊图标", "工厂列表和详情标题", "512×512，透明背景", "小型手工作坊", "生成一个透明背景工厂图标：起步小作坊。小型木质或砖石作坊，有小烟囱、简单工作台、少量金币，明亮可爱，轻度卡通经营游戏风格，居中，无文字。", "不要文字，不要真实照片，不要暗黑破败，不要复杂背景。", "PNG 透明背景", "factory_workshop_unlocked.png", "待制作"],
  ["A017", "P0", "工厂图标", "木材加工厂图标", "工厂列表和详情标题", "512×512，透明背景", "木材厂、原木、锯片", "生成一个透明背景工厂图标：木材加工厂。画面包含小厂房、原木、锯片和木板，明亮干净，轻度卡通经营游戏风格，居中，无文字。", "不要文字，不要血迹，不要真实照片，不要森林大背景。", "PNG 透明背景", "factory_lumber_unlocked.png", "待制作"],
  ["A018", "P0", "工厂图标", "食品加工厂图标", "工厂列表和详情标题", "512×512，透明背景", "食品流水线、包装盒", "生成一个透明背景工厂图标：食品加工厂。画面包含明亮厂房、食品传送带、包装盒和金币，干净卫生，轻度卡通经营游戏风格，居中，无文字。", "不要文字，不要真实照片，不要脏乱厨房，不要人物特写。", "PNG 透明背景", "factory_food_unlocked.png", "待制作"],
  ["A019", "P0", "工厂图标", "钢铁冶炼厂图标", "工厂列表和详情标题", "512×512，透明背景", "钢炉、钢锭、橙色熔光", "生成一个透明背景工厂图标：钢铁冶炼厂。画面包含坚固厂房、钢炉、钢锭和温暖橙色熔光，明亮但有工业力量感，轻度卡通风格，居中，无文字。", "不要文字，不要黑暗污染，不要真实照片，不要危险血腥。", "PNG 透明背景", "factory_steel_unlocked.png", "待制作"],
  ["A020", "P0", "工厂图标", "电子制造厂图标", "工厂列表和详情标题", "512×512，透明背景", "芯片、蓝色科技灯、装配线", "生成一个透明背景工厂图标：电子制造厂。画面包含现代厂房、芯片、电路板、蓝色科技灯和金币，明亮精致，轻度卡通经营游戏风格，居中，无文字。", "不要文字，不要过暗赛博朋克，不要真实照片，不要复杂背景。", "PNG 透明背景", "factory_electronics_unlocked.png", "待制作"],
  ["A021", "P0", "工厂图标", "机器人装配厂图标", "工厂列表和详情标题", "512×512，透明背景", "机器人手臂、未来工厂", "生成一个透明背景工厂图标：机器人装配厂。画面包含未来感厂房、机器人手臂、装配线和金币，明亮高级，轻度卡通经营游戏风格，居中，无文字。", "不要文字，不要暗黑机甲，不要战斗机器人，不要真实照片。", "PNG 透明背景", "factory_robotics_unlocked.png", "待制作"],
  ["A022", "P1", "工厂图标", "工厂未解锁遮罩", "所有工厂锁定状态通用覆盖", "512×512，透明背景", "半透明暗色 + 锁", "生成一个透明背景的锁定状态覆盖图，用于工厂图标未解锁状态，包含半透明暗色遮罩和小锁图案，边缘柔和，适合叠加在图标上，无文字。", "不要文字，不要完全遮住图标，不要恐怖锁链，不要复杂背景。", "PNG 透明背景", "overlay_factory_locked.png", "待制作"],
  ["A023", "P1", "工厂图标", "工厂选中高亮框", "当前选中工厂列表按钮", "512×512 或九宫格", "金色描边/蓝色发光", "设计一个透明背景的选中高亮框，用于工厂图标或列表项，金色描边，轻微蓝色光效，低调精致，适合经营游戏 UI，无文字。", "不要文字，不要过度发光，不要复杂背景。", "PNG 透明背景", "ui_factory_selected_highlight.png", "待制作"],
  ["A024", "P0", "工人", "普通工人图标", "工人数量、雇佣入口", "512×512，透明背景", "安全帽工人", "生成一个透明背景普通工人图标，角色戴安全帽和工作服，友好可爱，手拿工具或金币，适合休闲工厂经营游戏，半身或全身居中，无文字。", "不要文字，不要真实照片，不要夸张表情，不要危险姿势。", "PNG 透明背景", "worker_basic.png", "待制作"],
  ["A025", "P1", "工人", "熟练工人图标", "后续工人品质/升级表现", "512×512，透明背景", "更专业的工人", "生成一个透明背景熟练工人图标，角色戴高级安全帽和整洁工作服，手持平板或扳手，看起来更专业，明亮轻度卡通风格，无文字。", "不要文字，不要真实照片，不要严肃写实。", "PNG 透明背景", "worker_skilled.png", "待制作"],
  ["A026", "P0", "操作图标", "雇佣图标", "雇佣工人按钮内图标", "256×256，透明背景", "加号 + 工人", "生成一个透明背景图标，表示雇佣工人，元素包括工人头像、加号和金币，清晰简洁，轻度卡通经营游戏风格，无文字。", "不要文字，不要复杂背景，不要写实照片。", "PNG 透明背景", "icon_hire_worker.png", "待制作"],
  ["A027", "P0", "操作图标", "工人升级图标", "升级工人按钮内图标", "256×256，透明背景", "工人 + 上升箭头", "生成一个透明背景图标，表示升级工人，元素包括工人安全帽、向上箭头、星星或齿轮，明亮清晰，轻度卡通风格，无文字。", "不要文字，不要复杂背景，不要写实。", "PNG 透明背景", "icon_upgrade_worker.png", "待制作"],
  ["A028", "P0", "操作图标", "工厂升级图标", "升级工厂按钮内图标", "256×256，透明背景", "工厂 + 上升箭头", "生成一个透明背景图标，表示升级工厂，元素包括小工厂、向上箭头、齿轮和金币，经营模拟游戏风格，清晰居中，无文字。", "不要文字，不要复杂背景，不要暗色污染风。", "PNG 透明背景", "icon_upgrade_factory.png", "待制作"],
  ["A029", "P1", "弹窗", "离线收益弹窗插图", "离线收益弹窗装饰", "640×360，透明或浅背景", "夜间工厂仍在工作", "生成一张离线收益弹窗插图：夜晚的小工厂仍在自动运转，窗户亮着灯，金币从传送带上出现，温暖可爱，轻度卡通经营游戏风格，无文字。", "不要文字，不要阴森恐怖，不要真实照片，不要过暗。", "PNG", "illustration_offline_earnings.png", "待制作"],
  ["A030", "P1", "弹窗", "删除存档确认插图", "确认“抛弃工厂和员工”时使用", "640×360，透明或浅背景", "工人和工厂依依不舍", "生成一张删除存档确认弹窗插图，工厂门口有几名可爱的工人依依不舍地看着玩家，背景是小工厂和金币箱，情绪温柔但不夸张，轻度卡通经营游戏风格，无文字。", "不要文字，不要悲伤过度，不要恐怖，不要真实照片。", "PNG", "illustration_delete_save_confirm.png", "待制作"],
  ["A031", "P1", "弹窗", "通用弹窗面板", "设置、确认、离线收益统一皮肤", "九宫格切片，建议 600×360", "深蓝灰 + 金属边", "设计一个游戏通用弹窗面板皮肤，深蓝灰底，金属边框，轻微齿轮装饰，适合设置、确认、离线收益弹窗，低圆角，留出文字区域，无文字。", "不要文字，不要花哨背景，不要过大圆角。", "PNG 透明背景 / 9-slice", "ui_modal_panel_9slice.png", "待制作"],
  ["A032", "P1", "特效", "解锁工厂特效", "新工厂解锁反馈", "序列帧或 512×512 精灵", "金币爆发 + 光圈", "生成一组透明背景解锁特效素材，表现新工厂解锁，包含金色光圈、金币飞散、星星和齿轮粒子，轻度卡通，适合做序列帧或粒子贴图，无文字。", "不要文字，不要过度遮挡，不要真实爆炸，不要火灾效果。", "PNG 透明背景 / 序列帧", "fx_factory_unlock.png", "待制作"],
  ["A033", "P1", "特效", "升级成功特效", "升级工人/工厂反馈", "序列帧或 512×512 精灵", "箭头、星星、齿轮", "生成一组透明背景升级成功特效素材，包含向上箭头、星星、齿轮光效和少量金币，明亮轻快，适合经营游戏按钮反馈，无文字。", "不要文字，不要复杂背景，不要爆炸火焰。", "PNG 透明背景 / 序列帧", "fx_upgrade_success.png", "待制作"],
  ["A034", "P1", "特效", "金币飞行动画素材", "领取收益、离线收益、产出反馈", "序列帧或多张 128×128", "旋转金币", "生成一组透明背景金币飞行动画素材，金币有轻微旋转、高光变化，可用于从工厂飞到金币栏，轻度卡通，边缘干净，无文字。", "不要文字，不要背景，不要真实硬币照片。", "PNG 透明背景 / 序列帧", "fx_coin_fly_sequence.png", "待制作"],
  ["A035", "P2", "未来扩展", "经理系统图标", "后续自动化系统入口", "256×256，透明背景", "经理头像 + 自动化齿轮", "生成一个透明背景经理系统图标，角色像工厂经理，戴安全帽或拿平板，旁边有自动化齿轮，明亮休闲经营游戏风格，无文字。", "不要文字，不要真实照片，不要西装过度正式。", "PNG 透明背景", "icon_manager_system.png", "待制作"],
  ["A036", "P2", "未来扩展", "科技树图标", "后续科技系统入口", "256×256，透明背景", "灯泡 + 电路 + 齿轮", "生成一个透明背景科技树图标，元素包括灯泡、电路板、齿轮和小工厂，明亮科技感，轻度卡通经营游戏风格，无文字。", "不要文字，不要复杂背景，不要暗黑科幻。", "PNG 透明背景", "icon_tech_tree.png", "待制作"],
];

const promptRules = [
  ["规则", "说明"],
  ["统一风格", "明亮、精致、轻度卡通、工厂经营模拟游戏风格。工业元素要干净、有趣、可爱，不要脏乱压抑。"],
  ["透明背景", "图标、按钮、面板、特效默认要求透明背景；背景图和插图可以使用完整背景。"],
  ["无文字", "除游戏 Logo 外，所有素材提示词都要求无文字，避免 AI 生成乱码。文字由 Godot UI 渲染。"],
  ["画幅", "主菜单和工厂背景使用 1280×720；图标使用 256×256 或 512×512；应用图标使用 1024×1024。"],
  ["UI 安全区", "背景图需要给标题、按钮、面板留出空间，不要把关键细节放在 UI 会遮挡的位置。"],
  ["负面提示词通用版", "不要文字，不要水印，不要低清晰度，不要真实照片，不要暗黑恐怖，不要血腥，不要复杂杂乱背景，不要过度发光。"],
];

const namingRows = [
  ["目录", "用途", "示例文件名"],
  ["assets/backgrounds/", "主菜单、工厂界面等大背景", "bg_main_menu_1280x720.png"],
  ["assets/logo/", "游戏标题 Logo 和品牌素材", "logo_idle_factory_cn.png"],
  ["assets/icons/factories/", "工厂图标和锁定遮罩", "factory_workshop_unlocked.png"],
  ["assets/icons/workers/", "工人、经理等角色图标", "worker_basic.png"],
  ["assets/icons/ui/", "金币、收益、升级、雇佣等功能图标", "icon_coin.png"],
  ["assets/ui/", "按钮、面板、下拉框、滑杆、进度条", "ui_button_primary_states.png"],
  ["assets/illustrations/", "弹窗插图、离线收益图", "illustration_offline_earnings.png"],
  ["assets/effects/", "金币飞行、升级、解锁特效", "fx_factory_unlock.png"],
  ["Godot 导入建议", "PNG 图标保持透明；按钮/面板使用九宫格切片；背景关闭滤镜后检查清晰度；特效可先用单张精灵再升级序列帧。", ""],
];

const overview = workbook.worksheets.add("总览");
overview.getRange("A1:B1").values = [["挂机工厂大亨：美术素材任务与 AI 提示词", ""]];
overview.getRange("A1:B1").merge();
styleTitle(overview.getRange("A1:B1"));
overview.getRange(`A3:B${overviewRows.length + 2}`).values = overviewRows;
applyBodyStyle(overview.getRange(`A3:B${overviewRows.length + 2}`));
overview.getRange("A3:A9").format = { fill: "#EAF4FF", font: { bold: true, color: "#1F4E78" }, verticalAlignment: "top", wrapText: true };
setWidths(overview, [180, 780]);

const taskSheet = workbook.worksheets.add("素材任务表");
const headers = ["ID", "优先级", "模块/界面", "素材名称", "用途/说明", "规格建议", "风格方向", "AI生成提示词", "负面提示词", "交付格式", "文件命名建议", "状态"];
taskSheet.getRange("A1:L1").values = [headers];
taskSheet.getRange(`A2:L${tasks.length + 1}`).values = tasks;
applyHeaderStyle(taskSheet.getRange("A1:L1"));
applyBodyStyle(taskSheet.getRange(`A2:L${tasks.length + 1}`));
taskSheet.freezePanes.freezeRows(1);
setWidths(taskSheet, [70, 70, 110, 160, 220, 160, 180, 520, 300, 150, 220, 90]);
taskSheet.getRange(`B2:B${tasks.length + 1}`).format.horizontalAlignment = "center";
taskSheet.getRange(`L2:L${tasks.length + 1}`).format.horizontalAlignment = "center";
taskSheet.getRange(`A2:L${tasks.length + 1}`).conditionalFormats.add("Custom", {
  formula: '=$B2="P0"',
  format: { fill: "#FFF3CD" },
});
taskSheet.getRange(`A2:L${tasks.length + 1}`).conditionalFormats.add("Custom", {
  formula: '=$B2="P1"',
  format: { fill: "#EAF4FF" },
});

const rules = workbook.worksheets.add("AI提示词规则");
rules.getRange("A1:B1").values = [["AI 生成统一规则", ""]];
rules.getRange("A1:B1").merge();
styleTitle(rules.getRange("A1:B1"));
rules.getRange(`A3:B${promptRules.length + 2}`).values = promptRules;
applyHeaderStyle(rules.getRange("A3:B3"));
applyBodyStyle(rules.getRange(`A4:B${promptRules.length + 2}`));
setWidths(rules, [180, 760]);
rules.freezePanes.freezeRows(3);

const naming = workbook.worksheets.add("命名与导入建议");
naming.getRange("A1:C1").values = [["文件命名与 Godot 导入建议", "", ""]];
naming.getRange("A1:C1").merge();
styleTitle(naming.getRange("A1:C1"));
naming.getRange(`A3:C${namingRows.length + 2}`).values = namingRows;
applyHeaderStyle(naming.getRange("A3:C3"));
applyBodyStyle(naming.getRange(`A4:C${namingRows.length + 2}`));
setWidths(naming, [240, 520, 280]);
naming.freezePanes.freezeRows(3);

for (const sheet of [overview, taskSheet, rules, naming]) {
  const used = sheet.getRange("A1:L80");
  try {
    used.format.autofitRows();
  } catch {}
}

const inspect = await workbook.inspect({
  kind: "table",
  range: "素材任务表!A1:L8",
  include: "values",
  tableMaxRows: 8,
  tableMaxCols: 12,
});
console.log(inspect.ndjson);

const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 50 },
  summary: "final formula error scan",
});
console.log(errors.ndjson);

await workbook.render({ sheetName: "素材任务表", range: "A1:L12", scale: 1 });
await workbook.render({ sheetName: "总览", range: "A1:B10", scale: 1 });
await workbook.render({ sheetName: "AI提示词规则", range: "A1:B10", scale: 1 });
await workbook.render({ sheetName: "命名与导入建议", range: "A1:C12", scale: 1 });

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);
console.log(outputPath);
