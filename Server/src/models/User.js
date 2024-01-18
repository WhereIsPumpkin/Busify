import { Schema, model } from "mongoose"

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
  gender: {
    type: Schema.Types.String,
    required: true,
  },
  verified: {
    type: Boolean,
    default: false,
  },
})

const User = model("User", userSchema)

export default User
