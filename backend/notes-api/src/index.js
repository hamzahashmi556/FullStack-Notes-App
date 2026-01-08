/** @type {import("mongoose").Model} */
// const Note = require("@models/note.model");   

const express = require('express')
const fs = require('fs')

require('./db/mongoose')

const Note = require('./models/notes')
const { log } = require('console')

const app = express()

app.use(express.json())

// CREATE
app.post('/notes', async (req, res) => {
    const note = new Note(req.body)
    try {
        await note.save()
        res.status(201).send(note)
    }
    catch(error) {
        console.log(err)
        res.status(400).send(err)
    }
})

// READ
app.get('/notes', async (req, res) => {
    try {
        const notes = await Note.find()
        res.send(notes)
    }
    catch(err) {
        console.log(err)
        res.status(500).send(err)
    }
})

// UPDATE
app.patch('/notes/:id', async (req, res) => {
    try {
        let id = req.params.id
        const note = await Note.findById(id)

        note.note = req.body.note

        await note.save()

        res.status(200).send(note)
    }
    catch (error) {
        res.status(404).send(err)
    }
})

// DELETE
app.delete('/notes/:id', async (req, res) => {
    try {
        const note = await Note.findByIdAndDelete(req.params.id)
        if (!note) {
            return res.status(404).send("No note found to be deleted")
        }
        res.status(200).send("The note has been successfully delete BC!!!")
    }
    catch(error) {
        console.log(error)
        res.status(404).send(error)
    }
})

app.listen(3000, () => {
    console.log("server is up running on port 3000")
})