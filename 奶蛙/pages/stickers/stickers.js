const { categories, stickers } = require("../../utils/data")

Page({
  data: {
    categories,
    stickers,
    activeCategory: "all",
    displayStickers: stickers
  },

  changeCategory(event) {
    const key = event.currentTarget.dataset.key
    this.setData({
      activeCategory: key,
      displayStickers: key === "all" ? stickers : stickers.filter((item) => item.category === key)
    })
  },

  openDetail(event) {
    wx.navigateTo({
      url: `/pages/detail/detail?id=${event.currentTarget.dataset.id}`
    })
  },

  onShareAppMessage() {
    return {
      title: "这里有一窝魔性奶蛙",
      path: "/pages/stickers/stickers"
    }
  }
})
