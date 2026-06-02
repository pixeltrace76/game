const { stickers } = require("../../utils/data")
const storage = require("../../utils/storage")

function drawFrog(ctx, face) {
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
}

function drawCenteredText(ctx, text, y, size) {
  ctx.setFillStyle("#1D2B1A")
  ctx.setFontSize(size)
  ctx.setTextAlign("center")
  ctx.setTextBaseline("middle")
  ctx.fillText(text, 180, y)
}

Page({
  data: {
    sticker: null,
    favoriteText: "收藏这只蛙"
  },

  onLoad(options) {
    const sticker = stickers.find((item) => item.id === options.id) || stickers[0]
    this.setData({
      sticker,
      favoriteText: storage.isFavorite(sticker.id) ? "取消收藏" : "收藏这只蛙"
    })
  },

  toggleFavorite() {
    const isFavorite = storage.toggleFavorite(this.data.sticker.id)
    this.setData({
      favoriteText: isFavorite ? "取消收藏" : "收藏这只蛙"
    })
    wx.showToast({
      title: isFavorite ? "已收藏" : "已取消",
      icon: "none"
    })
  },

  savePoster() {
    const sticker = this.data.sticker
    if (sticker.useAsset && sticker.asset) {
      wx.getImageInfo({
        src: sticker.asset,
        success: (res) => this.saveToAlbum(res.path),
        fail: () => this.drawGeneratedPoster(sticker)
      })
      return
    }
    this.drawGeneratedPoster(sticker)
  },

  drawGeneratedPoster(sticker) {
    const ctx = wx.createCanvasContext("posterCanvas", this)
    drawFrog(ctx, sticker.face)
    drawCenteredText(ctx, sticker.text, 292, sticker.text.length > 5 ? 34 : 42)
    ctx.draw(false, () => {
      wx.canvasToTempFilePath({
        canvasId: "posterCanvas",
        width: 360,
        height: 360,
        destWidth: 720,
        destHeight: 720,
        success: (res) => this.saveToAlbum(res.tempFilePath),
        fail: () => {
          wx.showToast({ title: "生成失败，再点一次", icon: "none" })
        }
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
          content: "打开权限后就能保存奶蛙表情。",
          confirmText: "去打开",
          success: (res) => {
            if (res.confirm) wx.openSetting()
          }
        })
      }
    })
  },

  onShareAppMessage() {
    const sticker = this.data.sticker
    return {
      title: `${sticker.text}，这只奶蛙太魔性了`,
      path: `/pages/detail/detail?id=${sticker.id}`
    }
  }
})
