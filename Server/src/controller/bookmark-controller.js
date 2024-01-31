import User from "../models/User.js"
import jwt from "jsonwebtoken"
import dotenv from "dotenv"
dotenv.config()

export const addBookmark = async (req, res) => {
  try {
    const { userId, busStopNumber } = req.body

    const user = await User.findById(userId)
    if (!user) {
      return res.status(404).json({ message: "User not found." })
    }

    if (!user.bookmarkedStops.includes(busStopNumber)) {
      user.bookmarkedStops.push(busStopNumber)
      await user.save()
    }

    res.status(200).json(user.bookmarkedStops)
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
}

export const removeBookmark = async (req, res) => {
  try {
    const { userId, busStopNumber } = req.body

    const user = await User.findById(userId)
    if (!user) {
      return res.status(404).json({ message: "User not found." })
    }

    user.bookmarkedStops = user.bookmarkedStops.filter(
      (stop) => stop !== busStopNumber
    )
    await user.save()

    res.status(200).json(user.bookmarkedStops)
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
}
