import { Schema, model } from "mongoose"
import cardSchema from "./Card.js"

const userSchema = new Schema({
  name: {
    type: Schema.Types.String,
    required: true,
  },
  lastName: {
    type: Schema.Types.String,
    required: true,
  },
  email: {
    type: Schema.Types.String,
    required: true,
    unique: true,
  },
  password: {
    type: Schema.Types.String,
    required: true,
  },
  verified: {
    type: Boolean,
    default: false,
  },
  bookmarkedStops: {
    type: [Schema.Types.String],
    default: [],
  },
  balance: {
    type: Schema.Types.Number,
    default: 0,
  },
  card: {
    type: cardSchema,
    default: () => ({ cardNumber: '', cardName: '', cardDate: '', cardCVV: '' })
  },
})

const User = model("User", userSchema)

export default User
