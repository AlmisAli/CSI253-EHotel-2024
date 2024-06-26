const express = require('express');
const EhotelRoutes = require('./src/Ehotel/routes');

const app = express();
const port = 3000;

app.use(express.json());

app.get("/", (req, res) => {
    res.send("Hello World!");
});

app.use('/api/v1/EhotelClients', EhotelRoutes);

app.listen(port, () => console.log(`app listening on port ${port}`))