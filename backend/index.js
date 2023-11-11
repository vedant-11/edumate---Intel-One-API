const express = require("express");
const app = express();
const mongoose = require("mongoose");
require("dotenv").config();
const port = process.env.PORT || 8000;
const router = require("./router/student");
const subRouter = require("./router/subjectRouter");
const cors = require("cors");

const bodyParser = require("body-parser");
const { OpenAIApi, Configuration } = require("openai");

app.use(bodyParser.json());

app.use(cors());

app.use(express.json());
app.use("/student", router);
app.use("/subject", subRouter);
app.use("/faculty", require("./router/facultyRouter"));

//open ai code

const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});

app.post("/question", (req, res) => {
  const { topic } = req.body;

  // Generate the prompt for GPT-3
  const prompt = `Generate 5 MCQ questions for ${topic}. in the pattern of given manner dont add any other message:Question: What is the capital of France? 
  Options: A) Paris, B) Rome, C) Berlin
  Answer: A) Paris`;

  // Call the GPT-3 model to generate explanation
  generateUsingOpenAI(prompt)
    .then((explanation) => {
      const questionBlocks = explanation.trim().split("\n\n");

      const questions = questionBlocks.map((block, index) => {
        const lines = block.split("\n");

        const questionText = lines[0].replace("Question: ", "").trim();
        const optionsText = lines[1].replace("Options: ", "").trim();
        const answerText = lines[2]
          ? lines[2].replace("Answer: ", "").trim()
          : null;

        const options = optionsText.split(",").map((option) => option.trim());

        return {
          question: questionText,
          answers: options,
          id: (index + 1).toString(), // Convert index to string to use as an ID.
          markedAnswer: answerText,
        };
      });

      res.json(questions);
    })
    .catch((error) => {
      console.error("Error generating explanation:", error.response.data);
      res
        .status(500)
        .json({ error: "An error occurred while generating explanation." });
    });
});

app.post("/sentiment", (req, res) => {
  const { text } = req.body;
  const prompt = `Find whether given ${text} is a question related to computer science or not.If it is a question related to computer science then only say yes otherwise say no. for example: Is java a programming language? yes ,Is java a fruit? no  `;
  generateUsingOpenAI(prompt)
    .then((response) => {
      res.json({ response });
    })
    .catch((error) => {
      console.error("Error generating explanation:", error.response.data);
      res
        .status(500)
        .json({ error: "An error occurred while generating explanation." });
    });
});
app.post("/ask", (req, res) => {
  const { text } = req.body;
  const prompt = `You are a car salesman and you are asked this ${text} reply them with a good answer. for example: What is the mileage of this car? The mileage of this car is 18kmpl.  `;
  generateUsingOpenAI(prompt)
    .then((response) => {
      res.json({ response });
    })
    .catch((error) => {
      console.error("Error generating explanation:", error.response.data);
      res
        .status(500)
        .json({ error: "An error occurred while generating explanation." });
    });
});

async function generateUsingOpenAI(prompt) {
  const openai = new OpenAIApi(configuration);
  const response = await openai.createCompletion({
    model: "text-davinci-003",
    prompt: prompt,
    temperature: 1,
    max_tokens: 100,
    top_p: 1,
    frequency_penalty: 0,
    presence_penalty: 0,
  });
  return response.data.choices[0].text.trim();
}

mongoose
  .connect(process.env.URI)
  .then(() => {
    app.listen(process.env.PORT, () => {
      console.log("server started", process.env.PORT);
    });
  })
  .catch((error) => {
    console.error(error);
  });
