const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const config = require('../config/config');
const checkAuth = require('../middleware/checkAuth');
const db = require('../model/db');

router.post('/sign-up', async(req, res, next) => {
    const email = req.body.email;
    const password = req.body.password;
    if(!email || !password) {
        res.status(300).json({
            success: false,
            meessage: 'please provide email and password'
        })
    } else {
        const isExist = await db.userSchema.find({email: email});
        if (isExist.length > 0) {
            res.status(400).json({
                success: false,
                message: 'Email is already exists'
            });
        } else{
            const user = new db.userSchema();
            user.email = email;
            user.password = password;
            
            let result = await user.save()
            
            const token = jwt.sign(
                {
                user: result,
                },
                config.privateKey,{
                expireIn: '1h'
                }
            )
            res.json({ token, expireIn: '360000', userId: result._id });
        }
       
    }
    
});

router.post('/login', async (req, res) => {
    console.log(req.body);
    if (req.body.email && req.body.password) {
        let {token, userId} = await login(db, req.body.email, req.body.password, req, res);
        
        if (token != undefined) {
            res.json({
                success: true,
                token: token,
                expireIn: '36',
                userId
            });
        }
    } else {
        res.status(400).json({
            success: false,
            message: 'please provide correct email and password'
        });
    }

});

async function login(db, email, password, req, res) {
    const query = {email: email, password: password};
    let result = await db.userSchema.findOne(query);
    //console.log(result)
    if (result == null) {
        res.status(400).json({
            success: false,
            message: 'email or password not correct'
        })
    } else {
        let token = jwt.sign(
            {user: result},
            config.privateKey,
            {expiresIn: '36s'}
        )

        return {token, userId: result._id};
    }
}

router.get('/aa', (req, res, next) => {
    const m = new Map();
    m.set('a', 1);
    m.set(1, 2);
    for (let [key, value] of m.entries()) {
        console.log(`${key}: ${value}`);
    }

    l = [];
    l.push('aaaa');
    l.forEach((item) => console.log(item));

    res.cookie('cookie1', 'aa', {httpOnly: true, secure: true});
    res.cookie('cookie2', 'bb');
    res.clearCookie('cookie2');
    res.sendFile('/token.txt');
    res.send();

    
});


module.exports = router;