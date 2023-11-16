const express = require('express');
const app = express();


app.use(express.json());
const userRouter=require('./user');
app.use('/user',userRouter);

app.listen(3000, console.log("Server start on port 3000"));