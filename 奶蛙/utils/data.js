const categories = [
  { key: "all", name: "全部" },
  { key: "laugh", name: "大笑" },
  { key: "dance", name: "不知火舞" },
  { key: "shock", name: "震惊" },
  { key: "sassy", name: "阴阳" },
  { key: "sad", name: "委屈" },
  { key: "crazy", name: "发疯" },
  { key: "night", name: "晚安" }
]

const stickers = [
  {
    id: "laugh-001",
    title: "奶蛙大笑",
    category: "laugh",
    text: "哈哈蛙",
    action: "张嘴大笑，身体往后仰",
    face: "face-laugh",
    tag: "魔性大笑",
    useAsset: false,
    asset: "/assets/stickers/laugh-001.png"
  },
  {
    id: "dance-001",
    title: "奶蛙舞动",
    category: "dance",
    text: "蛙来咯",
    action: "扭身子跳舞，像突然开大",
    face: "face-sassy",
    tag: "不知火舞",
    useAsset: false,
    asset: "/assets/stickers/dance-001.png"
  },
  {
    id: "shock-001",
    title: "奶蛙震惊",
    category: "shock",
    text: "蛙不理解",
    action: "豆豆眼放空，嘴巴圆成一个洞",
    face: "face-shock",
    tag: "疑惑",
    useAsset: false,
    asset: "/assets/stickers/shock-001.png"
  },
  {
    id: "sassy-001",
    title: "奶蛙斜眼",
    category: "sassy",
    text: "就这呀",
    action: "歪头斜笑，脸上写满看破",
    face: "face-sassy",
    tag: "阴阳",
    useAsset: false,
    asset: "/assets/stickers/sassy-001.png"
  },
  {
    id: "sad-001",
    title: "奶蛙委屈",
    category: "sad",
    text: "蛙要碎了",
    action: "缩成一团，嘴巴下撇",
    face: "face-cry",
    tag: "破防",
    useAsset: false,
    asset: "/assets/stickers/sad-001.png"
  },
  {
    id: "crazy-001",
    title: "奶蛙发疯",
    category: "crazy",
    text: "蛙疯啦",
    action: "原地旋转，表情逐渐失控",
    face: "face-laugh",
    tag: "抽象",
    useAsset: false,
    asset: "/assets/stickers/crazy-001.png"
  },
  {
    id: "night-001",
    title: "奶蛙晚安",
    category: "night",
    text: "蛙先睡",
    action: "抱着小被子，困到眼睛打架",
    face: "face-cry",
    tag: "晚安",
    useAsset: false,
    asset: "/assets/stickers/night-001.png"
  },
  {
    id: "laugh-002",
    title: "奶蛙爆笑",
    category: "laugh",
    text: "笑到打鸣",
    action: "趴在地上拍地板",
    face: "face-laugh",
    tag: "哈哈哈",
    useAsset: false,
    asset: "/assets/stickers/laugh-002.png"
  },
  {
    id: "dance-002",
    title: "奶蛙火速出场",
    category: "dance",
    text: "别眨眼",
    action: "侧身冲出画面，带一点舞步",
    face: "face-sassy",
    tag: "登场",
    useAsset: false,
    asset: "/assets/stickers/dance-002.png"
  },
  {
    id: "shock-002",
    title: "奶蛙瞳孔地震",
    category: "shock",
    text: "啊？",
    action: "全身僵住，嘴巴慢慢张大",
    face: "face-shock",
    tag: "啊？",
    useAsset: false,
    asset: "/assets/stickers/shock-002.png"
  },
  {
    id: "sassy-002",
    title: "奶蛙已读",
    category: "sassy",
    text: "蛙看见了",
    action: "双手背后，微微点头",
    face: "face-sassy",
    tag: "已读",
    useAsset: false,
    asset: "/assets/stickers/sassy-002.png"
  },
  {
    id: "sad-002",
    title: "奶蛙退下",
    category: "sad",
    text: "蛙先退下",
    action: "慢慢后退，眼神飘走",
    face: "face-cry",
    tag: "撤退",
    useAsset: false,
    asset: "/assets/stickers/sad-002.png"
  }
]

const sounds = [
  { id: "sound-laugh", name: "奶蛙大笑", text: "哈！哈！蛙！", mood: "爆笑", src: "/assets/sounds/laugh.mp3" },
  { id: "sound-mai", name: "不知火舞", text: "舞！舞！蛙！", mood: "魔性", src: "/assets/sounds/mai.mp3" },
  { id: "sound-wow", name: "蛙哦", text: "蛙哦？", mood: "震惊", src: "/assets/sounds/wow.mp3" },
  { id: "sound-bo", name: "啵呱", text: "啵呱", mood: "可爱", src: "/assets/sounds/bogua.mp3" },
  { id: "sound-no", name: "蛙不懂", text: "蛙不懂", mood: "疑惑", src: "/assets/sounds/dontknow.mp3" },
  { id: "sound-run", name: "蛙先跑", text: "蛙先跑了", mood: "撤退", src: "/assets/sounds/run.mp3" },
  { id: "sound-break", name: "蛙碎了", text: "咔，蛙碎", mood: "破防", src: "/assets/sounds/break.mp3" },
  { id: "sound-night", name: "蛙晚安", text: "晚安蛙", mood: "晚安", src: "/assets/sounds/night.mp3" }
]

const quotes = [
  "今日奶蛙：笑一声，算开机。",
  "蛙不理解，但蛙尊重。",
  "再问就是奶蛙正在加载。",
  "蛙先大笑，剩下的交给明天。",
  "事情很大，奶蛙很小。",
  "蛙来咯，别眨眼。",
  "今天也要做一只情绪很满的蛙。",
  "蛙看见了，蛙选择假装没看见。",
  "先别急，蛙已经开始抽象了。",
  "蛙的建议是：发出去。"
]

module.exports = {
  categories,
  stickers,
  sounds,
  quotes
}
