const hours = Array.from({ length: 13 }, (_, index) => index)
const minutes = Array.from({ length: 61 }, (_, index) => index)
const seconds = Array.from({ length: 61 }, (_, index) => index)
const LAUGH_AUDIO_SRC = "/assets/sounds/laugh.mp3"

function formatTime(totalSeconds) {
  const hour = Math.floor(totalSeconds / 3600)
  const minute = Math.floor((totalSeconds % 3600) / 60)
  const second = totalSeconds % 60
  return `${String(hour).padStart(2, "0")}:${String(minute).padStart(2, "0")}:${String(second).padStart(2, "0")}`
}

function getTotalSeconds(values) {
  const hour = hours[values[0]] || 0
  const minute = minutes[values[1]] || 0
  const second = seconds[values[2]] || 0
  return hour * 3600 + minute * 60 + second
}

function getPickerValue(totalSeconds) {
  const hour = Math.floor(totalSeconds / 3600)
  const minute = Math.floor((totalSeconds % 3600) / 60)
  const second = totalSeconds % 60
  return [hour, minute, second]
}

function getButtonText(totalSeconds) {
  return totalSeconds > 0 ? `开始 ${formatTime(totalSeconds)}` : "请选择时间"
}

Page({
  data: {
    idleGif: "/assets/idle.gif",
    laughGif: "/assets/laugh.gif",
    hours,
    minutes,
    seconds,
    pickerValue: [0, 0, 10],
    pickerMoving: false,
    counting: false,
    playing: false,
    remainingSeconds: 10,
    buttonText: "开始 00:00:10"
  },

  onLoad() {
    this.audio = wx.createInnerAudioContext()
    this.audio.obeyMuteSwitch = false
    this.audio.loop = false
    this.audio.src = LAUGH_AUDIO_SRC
    this.audio.onPlay(() => this.setData({ playing: true }))
    this.audio.onStop(() => this.setData({ playing: false }))
    this.audio.onEnded(() => {
      if (!this.audio.loop) {
        this.setData({ playing: false })
      }
    })
    this.audio.onError(() => this.handleAudioError())
  },

  onPickerChange(event) {
    if (this.data.counting || this.data.playing) return
    const pickerValue = event.detail.value
    const totalSeconds = getTotalSeconds(pickerValue)
    this.setData({
      pickerValue,
      remainingSeconds: totalSeconds,
      buttonText: getButtonText(totalSeconds)
    })
  },

  onPickStart() {
    if (this.data.counting || this.data.playing) return
    this.setData({ pickerMoving: true })
  },

  onPickEnd() {
    if (this.pickEndTimer) {
      clearTimeout(this.pickEndTimer)
    }
    this.pickEndTimer = setTimeout(() => {
      this.setData({ pickerMoving: false })
      this.pickEndTimer = null
    }, 160)
  },

  handleTimerTap() {
    if (this.data.playing) {
      this.stopLaugh()
      return
    }
    if (this.data.counting) {
      this.cancelTimer()
      return
    }
    const totalSeconds = getTotalSeconds(this.data.pickerValue)
    if (totalSeconds <= 0) {
      wx.showToast({
        title: "请选择时间",
        icon: "none"
      })
      return
    }
    this.startTimer(totalSeconds)
  },

  startTimer(secondsValue) {
    this.clearTimer()
    this.countdownEndAt = Date.now() + secondsValue * 1000
    this.setData({
      counting: true,
      remainingSeconds: secondsValue,
      pickerValue: getPickerValue(secondsValue),
      buttonText: `取消 ${formatTime(secondsValue)}`
    })
    this.scheduleTick()
  },

  scheduleTick() {
    if (!this.data.counting) return
    const remainingMs = Math.max(0, this.countdownEndAt - Date.now())
    const next = Math.ceil(remainingMs / 1000)

    if (next <= 0) {
      this.finishCountdown()
      return
    }

    if (next !== this.data.remainingSeconds) {
      this.setData({
        remainingSeconds: next,
        pickerValue: getPickerValue(next),
        buttonText: `取消 ${formatTime(next)}`
      })
    }

    const delay = Math.max(80, remainingMs % 1000 || 1000)
    this.timer = setTimeout(() => {
      this.timer = null
      this.scheduleTick()
    }, delay)
  },

  finishCountdown() {
    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = null
    }
    this.setData({
      remainingSeconds: 0,
      pickerValue: getPickerValue(0),
      buttonText: `取消 ${formatTime(0)}`
    })
    this.finishDelayTimer = setTimeout(() => {
      this.finishDelayTimer = null
      this.finishTimer()
    }, 420)
  },

  cancelTimer() {
    this.clearTimer()
    const totalSeconds = getTotalSeconds(this.data.pickerValue)
    this.setData({
      counting: false,
      remainingSeconds: totalSeconds,
      pickerValue: getPickerValue(totalSeconds),
      buttonText: getButtonText(totalSeconds)
    })
    wx.showToast({
      title: "已取消",
      icon: "none"
    })
  },

  finishTimer() {
    this.clearTimer()
    const totalSeconds = getTotalSeconds(this.data.pickerValue)
    this.lastSelectedSeconds = totalSeconds
    this.setData({
      counting: false,
      remainingSeconds: totalSeconds,
      pickerValue: getPickerValue(totalSeconds),
      buttonText: "点击空白处暂停"
    })
    this.playLaugh()
  },

  clearTimer() {
    if (this.timer) {
      clearTimeout(this.timer)
      this.timer = null
    }
    this.countdownEndAt = null
    if (this.pickEndTimer) {
      clearTimeout(this.pickEndTimer)
      this.pickEndTimer = null
    }
    if (this.finishDelayTimer) {
      clearTimeout(this.finishDelayTimer)
      this.finishDelayTimer = null
    }
  },

  playLaugh() {
    wx.vibrateShort({ type: "heavy" })
    wx.setInnerAudioOption({
      obeyMuteSwitch: false,
      mixWithOther: false
    })
    this.audio.stop()
    this.audio.src = LAUGH_AUDIO_SRC
    this.audio.loop = true
    this.audio.play()
  },

  handleAudioError() {
    const totalSeconds = getTotalSeconds(this.data.pickerValue)
    this.setData({
      playing: false,
      buttonText: getButtonText(totalSeconds)
    })
    wx.showToast({
      title: "请放入 laugh.mp3",
      icon: "none"
    })
  },

  handleBlankTap() {
    if (!this.data.playing) return
    this.stopLaugh()
  },

  stopLaugh() {
    const totalSeconds = typeof this.lastSelectedSeconds === "number"
      ? this.lastSelectedSeconds
      : getTotalSeconds(this.data.pickerValue)
    this.audio.stop()
    this.audio.loop = false
    this.setData({
      playing: false,
      pickerValue: getPickerValue(totalSeconds),
      remainingSeconds: totalSeconds,
      pickerMoving: false,
      buttonText: getButtonText(totalSeconds)
    })
  },

  noop() {},

  onUnload() {
    this.clearTimer()
    if (this.audio) {
      this.audio.destroy()
    }
  },

  onShareAppMessage() {
    return {
      title: "奶蛙倒计时",
      path: "/pages/index/index"
    }
  }
})
