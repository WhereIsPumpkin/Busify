import mongoose from "mongoose";

const connectToMongoDB = async () => {
    const url = process.env.MONGO_URL;

    try {
        await mongoose.connect(url);
        console.log("MongoDB connected successfully");
    } catch (error) {
        console.error("MongoDB connection error:", error.message);
        throw error;
    }
};

export default connectToMongoDB;
