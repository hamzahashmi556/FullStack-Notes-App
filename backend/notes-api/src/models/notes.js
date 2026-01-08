const mongoose = require('mongoose');

const noteSchema = mongoose.Schema({
    note: {
        type: String,
        required: true
    }
})

const Note = mongoose.model('note', noteSchema)

module.exports = Note