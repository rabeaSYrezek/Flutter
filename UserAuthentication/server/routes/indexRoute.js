const express = require('express');
const router = express.Router();
const db = require('../model/db');
const checkAuth = require('../middleware/checkAuth');

router.get('/', checkAuth, async(req, res, next) => {
    const creatorId = req.decodedToken.user._id;

    let result = await db.productSchema.find({userId: creatorId})
    res.json(result);
})

router.post('/', checkAuth, (req, res, next) => {
    const title = req.body.title;
    const price = req.body.price;
    const description = req.body.description;
    const imageUrl = req.body.imageUrl;
    const isFavorite = req.body.isFavorite;
    const creatorId = req.body.creatorId;
    console.log(creatorId);

    const product = new db.productSchema();
    product.title = title;
    product.imageUrl = imageUrl;
    product.price = price;
    product.description = description;
    product.isFavorite = isFavorite;
    product.userId = creatorId;
    product.save((err, prod) => {
        console.log(prod);
        res.json({'id': prod._id});
    });  
    
});

router.patch('/update/:id', checkAuth, async (req, res, next) => {
    const filter = {_id: req.params.id};
    const update = {title: req.body.title, price: req.body.price, imageUrl: req.body.imageUrl, description: req.body.description}
    let newProduct = await db.productSchema.findOneAndUpdate(filter, update, {new: true});
    console.log(newProduct);
    res.json(newProduct);
})

router.delete('/delete/:id', checkAuth, async(req, res, next) => {
    const filter = {_id: req.params.id}
    const result = await db.productSchema.deleteOne(filter)
    res.status(111).send();
    console.log(result);
})

router.patch('/isFavorite/:ids', checkAuth, async(req, res, next) => {
    filter = {_id: req.params.ids}
    update = {isFavorite : req.body.isFavorite}
    let newProduct = await db.productSchema.findOneAndUpdate(filter, update);
    console.log(req.body, newProduct);
    res.status(111).send();
})

router.post('/add-order', checkAuth, async(req, res, next) => {
    const newOrder = new db.orderSchema();
    newOrder.amount = req.body.amount;
    newOrder.products = req.body.products;
    newOrder.userId = req.decodedToken.user._id;
    let result = await newOrder.save();
    console.log(result);
})

router.get('/get-orders', checkAuth, async(req, res, next) => {
    const userId = req.decodedToken.user._id;

    const result = await db.orderSchema.find({userId: userId});
    res.json(result);
})
module.exports = router;