const { stickers } = require("../../utils/data")
const storage = require("../../utils/storage")

Page({
  data: {
    favorites: []
  },

  onShow() {
    this.refresh()
  },

  refresh() {
    const ids = storage.getFavorites()
    const favorites = ids.map((id) => stickers.find((item) => item.id === id)).filter(Boolean)
    this.setData({ favorites })
  },

  openDetail(event) {
    wx.navigateTo({
      url: `/pages/detail/detail?id=${event.currentTarget.dataset.id}`
    })
  },

  removeFavorite(event) {
    storage.toggleFavorite(event.currentTarget.dataset.id)
    this.refresh()
    wx.showToast({ title: "已移除", icon: "none" })
  },

  goStickers() {
    wx.switchTab({ url: "/pages/stickers/stickers" })
  },

  onShareAppMessage() {
    return {
      title: "我的奶蛙收藏夹",
      path: "/pages/favorites/favorites"
    }
  }
})
