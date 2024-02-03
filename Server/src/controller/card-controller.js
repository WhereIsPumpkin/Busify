import User from "../models/User.js"
import dotenv from "dotenv"
dotenv.config()

export const addCard = async (req, res) => {
  const { cardNumber, cardName, cardDate, cardCVV } = req.body

  const userId = req.userData.id
  try {
    const user = await User.findById(userId)
    if (!user) {
      return res.status(404).json({ message: "User not found" })
    }

    user.card = { cardNumber, cardName, cardDate, cardCVV }

    await user.save()
    console.log("It is added")
    res.status(200).json({ message: "Card added successfully", user: user })
  } catch (error) {
    res.status(500).json({ message: "An error occurred", error: error.message })
  }
}

export const deleteCard = async (req, res) => {
  const userId = req.userData.id

  try {
    const user = await User.findById(userId)

    if (!user) {
      return res.status(404).json({ message: "User not found" })
    }

    if (!user.card) {
      return res.status(400).json({ message: "No card available to delete" })
    }

    user.card = null

    await user.save()
    console.log("Card is deleted")
    res.status(200).json({ message: "Card deleted successfully", user: user })
  } catch (error) {
    res.status(500).json({ message: "An error occured", error: error.message })
  }
}