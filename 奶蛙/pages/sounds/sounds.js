const { sounds } = require("../../utils/data")

Page({
  data: {
    sounds,
    playingId: ""
  },

  onLoad() {
    this.audio = wx.createInnerAudioContext()
    this.audio.onEnded(() => this.setData({ playingId: "" }))
    this.audio.onError(() => {
      this.setData({ playingId: "" })
      wx.showToast({
        title: "先放入音频文件",
        icon: "none"
      })
    })
  },

  playSound(event) {
    const id = event.currentTarget.dataset.id
    const sound = sounds.find((item) => item.id === id)
    if (!sound) return

    wx.vibrateShort({ type: "medium" })
    this.setData({ playingId: id })
    this.audio.stop()
    this.audio.src = sound.src
    this.audio.play()
  },

  onUnload() {
    if (this.audio) {
      this.audio.destroy()
    }
  },

  onShareAppMessage() {
    return {
      title: "奶蛙开嗓了，点一下试试",
      path: "/pages/sounds/sounds"
    }
  }
})
