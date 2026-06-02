const { quotes } = require("../../utils/data")

const moods = [
  { name: "大笑", face: "face-laugh" },
  { name: "震惊", face: "face-shock" },
  { name: "阴阳", face: "face-sassy" },
  { name: "委屈", face: "face-cry" }
]

const texts = [
  "哈哈蛙",
  "蛙不理解",
  "蛙来咯",
  "蛙先退下",
  "蛙要碎了",
  "就这呀",
  "啊？",
  "笑到打鸣",
  "蛙疯啦",
  "蛙先睡"
]

function drawFrog(ctx, face, text) {
  ctx.setFillStyle("#FDFBEA")
  ctx.fillRect(0, 0, 360, 360)

  ctx.setFillStyle("#C8F19A")
  ctx.beginPath()
  ctx.arc(132, 104, 42, 0, Math.PI * 2)
  ctx.arc(228, 104, 42, 0, Math.PI * 2)
  ctx.fill()

  ctx.setFillStyle("#B9EF8C")
  ctx.beginPath()
  ctx.arc(180, 166, 92, 0, Math.PI * 2)
  ctx.fill()

  ctx.setFillStyle("#1D2B1A")
  ctx.beginPath()
  ctx.arc(144, 104, 8, 0, Math.PI * 2)
  ctx.arc(216, 104, 8, 0, Math.PI * 2)
  ctx.fill()

  ctx.setFillStyle("rgba(255, 154, 139, 0.55)")
  ctx.beginPath()
  ctx.arc(126, 158, 13, 0, Math.PI * 2)
  ctx.arc(234, 158, 13, 0, Math.PI * 2)
  ctx.fill()

  ctx.setFillStyle("#25331E")
  if (face === "face-shock") {
    ctx.beginPath()
    ctx.arc(180, 176, 28, 0, Math.PI * 2)
    ctx.fill()
  } else if (face === "face-cry") {
    ctx.setLineWidth(8)
    ctx.beginPath()
    ctx.arc(180, 202, 30, Math.PI * 1.12, Math.PI * 1.88)
    ctx.stroke()
  } else if (face === "face-sassy") {
    ctx.save()
    ctx.translate(180, 178)
    ctx.rotate(-0.12)
    ctx.fillRect(-28, -5, 56, 10)
    ctx.restore()
  } else {
    ctx.beginPath()
    ctx.arc(180, 172, 40, 0, Math.PI)
    ctx.fill()
    ctx.setFillStyle("#FF8D86")
    ctx.beginPath()
    ctx.arc(180, 194, 16, 0, Math.PI, true)
    ctx.fill()
  }

  ctx.setFillStyle("#1D2B1A")
  ctx.setFontSize(text.length > 5 ? 34 : 42)
  ctx.setTextAlign("center")
  ctx.setTextBaseline("middle")
  ctx.fillText(text, 180, 292)
}

Page({
  data: {
    moods,
    text: "蛙不理解",
    currentFace: "face-laugh"
  },

  onInput(event) {
    this.setData({
      text: event.detail.value
    })
  },

  changeMood(event) {
    this.setData({
      currentFace: event.currentTarget.dataset.face
    })
  },

  randomText() {
    const pool = texts.concat(quotes.map((item) => item.replace("今日奶蛙：", "").slice(0, 12)))
    this.setData({
      text: pool[Math.floor(Math.random() * pool.length)]
    })
  },

  savePoster() {
    const text = this.data.text || "蛙不理解"
    const ctx = wx.createCanvasContext("createCanvas", this)
    drawFrog(ctx, this.data.currentFace, text)
    ctx.draw(false, () => {
      wx.canvasToTempFilePath({
        canvasId: "createCanvas",
        width: 360,
        height: 360,
        destWidth: 720,
        destHeight: 720,
        success: (res) => this.saveToAlbum(res.tempFilePath),
        fail: () => wx.showToast({ title: "生成失败，再试一次", icon: "none" })
      }, this)
    })
  },

  saveToAlbum(filePath) {
    wx.saveImageToPhotosAlbum({
      filePath,
      success: () => wx.showToast({ title: "已保存", icon: "success" }),
      fail: () => {
        wx.showModal({
          title: "需要相册权限",
          content: "打开权限后就能保存生成图。",
          confirmText: "去打开",
          success: (res) => {
            if (res.confirm) wx.openSetting()
          }
        })
      }
    })
  },

  onShareAppMessage() {
    return {
      title: "我刚生成了一只奶蛙",
      path: "/pages/create/create"
    }
  }
})
