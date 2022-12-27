const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const cors = require('cors');
const mongoose = require('mongoose');

const app = express();

mongoose.connect('mongodb://localhost/flutterHttpRequest', function(err) {
    if (err) {
        throw err;
    } else {
        console.log('Successfully conected to mongodb');
    }
});

const indexRoute = require('./routes/indexRoute');
const authRoute = require('./routes/register');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(morgan('dev'));
app.use(cors());

app.use('/index', indexRoute);
app.use('/auth', authRoute);

app.listen(3000, (err) => {
    if(err) {
        throw err;
    } else {
        console.log('app running on port 3000');
    }
})