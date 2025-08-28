const mongoose = require("mongoose");

const ChatbotInteractionSchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    input_type: {
        type: String,
        enum: ["text", "image", "text+image"],
        required: true,
    },
    similarities: {
        type: [Number],
        default: [],
    },
    similarity_metric: {
        top1: { type: Number, default: null },
        avg: { type: Number, default: null },
        top3_avg: { type: Number, default: null },
    }
}, { timestamps: true });

ChatbotInteractionSchema.pre("save", function (next) {
    if (this.similarities.length > 0) {
        // Top 1
        this.similarity_metric.top1 = this.similarities[0];

        // All Avg 
        const sum = this.similarities.reduce((a, b) => a + b, 0);
        this.similarity_metric.avg = sum / this.similarities.length;

        // Top-3 Avg
        const top3 = this.similarities.slice(0, 3);
        const top3Sum = top3.reduce((a, b) => a + b, 0);
        this.similarity_metric.top3_avg = top3Sum / top3.length;
    }
    next();
});

module.exports = mongoose.model("ChatbotInteraction", ChatbotInteractionSchema);
