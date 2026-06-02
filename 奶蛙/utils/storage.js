const FAVORITES_KEY = "milkfrog_favorites"

function getFavorites() {
  return wx.getStorageSync(FAVORITES_KEY) || []
}

function setFavorites(ids) {
  wx.setStorageSync(FAVORITES_KEY, ids)
}

function isFavorite(id) {
  return getFavorites().indexOf(id) > -1
}

function toggleFavorite(id) {
  const ids = getFavorites()
  const index = ids.indexOf(id)
  if (index > -1) {
    ids.splice(index, 1)
  } else {
    ids.unshift(id)
  }
  setFavorites(ids)
  return ids.indexOf(id) > -1
}

module.exports = {
  getFavorites,
  isFavorite,
  toggleFavorite
}
