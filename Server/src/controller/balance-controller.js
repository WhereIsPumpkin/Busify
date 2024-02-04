import User from "../models/User.js"
import dotenv from "dotenv"
dotenv.config()

export const fillBalance = async (req, res) => {
  const userId = req.userData.id

  const { amountToAdd } = req.body

  if (!amountToAdd || amountToAdd <= 0) {
    return res.status(400).json({ message: "Invalid amount to add" })
  }

  try {
    const user = await User.findById(userId)

    if (!user) {
      return res.status(404).json({ message: "User not found" })
    }

    user.balance += amountToAdd

    await user.save()

    return res.status(200).json({
      message: "Balance updated successfully",
      balance: user.balance,
    })
  } catch (error) {
    return res
      .status(500)
      .json({ message: "An error occurred while updating the balance" })
  }
}
  
