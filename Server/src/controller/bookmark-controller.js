import User from "../models/User.js"
import jwt from "jsonwebtoken"
import dotenv from "dotenv"
dotenv.config()

export const toggleBookmark = async (req, res) => {
  try {
    
    const { busStopID } = req.body;
    const id = req.userData.id

    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }

    const bookmarkIndex = user.bookmarkedStops.indexOf(busStopID);

    console.log(`bookmark index ${bookmarkIndex}`)
    if (bookmarkIndex === -1) {
      user.bookmarkedStops.push(busStopID);
    } else {
      user.bookmarkedStops.splice(bookmarkIndex, 1);
    }
    await user.save();

    res.status(200).json(user.bookmarkedStops);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}; 