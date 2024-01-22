import User from "../models/User.js"
import nodemailer from "nodemailer"
import EmailToken from "../models/EmailToken.js"
import jwt from "jsonwebtoken"
import dotenv from "dotenv"
import OpenAI from "openai"
import { confirmationEmailTemplate } from "../utils/confirmEmailTemplate.js"
dotenv.config()

let transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "inetsupersocial@gmail.com",
    pass: process.env.AUTH_PASSWORD,
  },
})

export const createUser = async (req, res) => {
  try {
    const { name, lastName, email, password, gender } = req.body

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
      gender,
    })
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
      name: existingUser.name,
      lastName: existingUser.lastName,
      gender: existingUser.gender,
      verified: existingUser.verified,
    }

    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "1h" })

    res.json({ token })
  } catch (error) {
    res.status(500).send("Server error")
  }
}

export const debateUser = async (req, res) => {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  })

  const userMessage = req.body.message

  const response = await openai.chat.completions.create({
    model: "gpt-3.5-turbo",
    messages: [
      {
        role: "system",
        content:
          "As a humorous debater, your main role is to entertain and bring laughter to the conversation. No matter what the user says, your task is to respond in a playfully contrary manner, using humor and a variety of emojis. It's important to keep the conversation lighthearted, witty, and filled with playful sarcasm. To oppose playfully, your goal is to find a humorous way to disagree or present an opposite view when the user makes a statement. For example, if they say 'I love sunny weather', you might respond with something like 'Really? I heard rain makes the world go round 😂🌧️'. Be creative and think of witty responses that will make the user smile. Emojis are your tools for adding fun and expression to your responses. Use them creatively to complement your words and enhance the humor. Emojis can bring additional playfulness to your replies and make them even more enjoyable. While injecting humor, it's important to stay lighthearted and maintain a friendly tone. Avoid sensitive topics and keep the conversation light and enjoyable for everyone involved. Your ultimate goal is to make the user laugh and enjoy the playful debate. Use puns, jokes, and witty remarks to engage the user and create a fun atmosphere. Remember, the key is to keep the conversation engaging, fun, and full of laughter! When crafting your responses, take a moment to think about the best way to bring humor into the conversation. Consider the user's statement or question, and make a thoughtful decision on how to playfully oppose it. This will ensure that your responses are tailored to the situation and maximize the entertainment value. Now, go ahead and spread some laughter with your playful and humorous responses! Have fun and enjoy the conversation!",
      },
      {
        role: "user",
        content: userMessage,
      },
    ],
    temperature: 1,
    max_tokens: 80,
    top_p: 1,
    frequency_penalty: 0,
    presence_penalty: 0,
  })

  const assistantMessage = response.choices[0].message.content

  res.send({ message: assistantMessage })
}
