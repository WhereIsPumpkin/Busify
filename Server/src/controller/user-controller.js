import User from "../models/User.js"
import nodemailer from "nodemailer"
import EmailToken from "../models/EmailToken.js"
import jwt from "jsonwebtoken"
import dotenv from "dotenv"
import { confirmationEmailTemplate } from "../utils/templates/confirmEmailTemplate.js"
import transporter from "../utils/configs/emailTransporter.js"
dotenv.config()

export const createUser = async (req, res) => {
  try {
    const { name, lastName, email, password } = req.body

    const userEmail = email.toLowerCase()
    const existingUserEmail = await User.findOne({ email: userEmail })

    if (existingUserEmail) {
      return res
        .status(409)
        .json({ message: "A user with this email already exists." })
    }

    function generateRandomFourDigitNumber() {
      return Math.floor(Math.random() * 9000) + 1000
    }

    const token = generateRandomFourDigitNumber()

    const emailToken = new EmailToken({
      token,
      email: userEmail,
    })

    await emailToken.save()

    try {
      await transporter.sendMail({
        from: "inetsupersocial@gmail.com",
        to: email,
        subject: "Please confirm your email",
        html: confirmationEmailTemplate(token),
      })
    } catch (error) {
      return res
        .status(500)
        .json({ error: "Failed to send confirmation email." })
    }

    const newUser = new User({
      name,
      lastName,
      email: userEmail,
      password,
      card: null,
    })
    console.log(newUser)
    await newUser.save()

    return res.status(201).json(newUser)
  } catch (error) {
    return res.status(500).json({ error: error.message })
  }
}

export const verifyUser = async (req, res) => {
  try {
    const { token, email } = req.body

    const userEmail = email.toLowerCase()

    const existingUser = await EmailToken.findOne({ email: userEmail })

    if (!existingUser) {
      return res.status(404).json({
        success: false,
        message: "User not found.",
      })
    }

    if (existingUser.token === token) {
      const updatedUser = await User.findOneAndUpdate(
        { email: userEmail },
        { verified: true },
        { new: true }
      )

      await EmailToken.findOneAndDelete({ email })

      return res.status(200).json({
        success: true,
        message: "User verified successfully.",
      })
    } else {
      return res.status(401).json({
        success: false,
        message: "Invalid token.",
      })
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error verifying user.",
    })
  }
}

export const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body

    const userEmail = email.toLowerCase()

    const existingUser = await User.findOne({ email: userEmail })
    if (!existingUser) {
      return res.status(404).send("User not found")
    }

    const validPassword = password === existingUser.password
    if (!validPassword) {
      return res.status(401).send("Invalid password")
    }

    const payload = {
      id: existingUser._id,
    }

    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "1w" })

    res.json({
      token,
      user: {
        id: existingUser._id,
        name: existingUser.name,
        lastName: existingUser.lastName,
        email: existingUser.email,
        bookmarkedStops: existingUser.bookmarkedStops,
        verified: existingUser.verified,
        balance: existingUser.balance,
        card: existingUser.card,
      },
    })
  } catch (error) {
    res.status(500).send("Server error")
  }
}

export const getUserInfo = async (req, res) => {
  try {
    const userID = req.userData.id
    const user = await User.findById(userID)

    const userInfo = {
      id: user._id,
      name: user.name,
      lastName: user.lastName,
      email: user.email,
      verified: user.verified,
      bookmarkedStops: user.bookmarkedStops,
      balance: user.balance,
    }

    const hasCardDetails =
      user.card &&
      Object.values(user.card.toObject()).some((value) => value !== "")
    if (hasCardDetails) {
      userInfo.card = user.card
    }

    res.json(userInfo)
  } catch (error) {
    res.status(500).send("Server error: " + error.message)
  }
}
