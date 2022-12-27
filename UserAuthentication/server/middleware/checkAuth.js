const jwt = require('jsonwebtoken');
const config = require('../config/config');

module.exports = function (req, res, next) {
    let token = req.headers["auth"];

    if (token) {
        jwt.verify(token, config.privateKey, function (err, decoded) {
            if (err) {
                res.json({
                    success: false,
                    message: 'not authenticated'
                });
            } else {
                req.decodedToken = decoded;
                next();
            }
        });
    } else {
        res.status(300).json({
            success: false,
            message: 'no token provided'
        });
    }
}