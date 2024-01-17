import User from "../models/User.js";

export const getUser = async (req, res ) => {
    const data = await User.find()
    d
    return res.status(200).json(data);
};