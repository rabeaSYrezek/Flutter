const mongoose = require('mongoose');
const schema = mongoose.Schema;
const deepPopulate = require('mongoose-deep-populate')(mongoose);

const userSchema = new schema({
    email: String,
    password: String,
    token: String,
    userOrders: {type: schema.Types.ObjectId, ref: 'orderSchema'}
});

const product = new schema({
    title: String,
    price: Number,
    description: String,
    imageUrl: String,
    isFavorite: {type: Boolean, default: false},
    userId:{type: schema.Types.ObjectId, ref: 'userSchema'}
});

const orderSchema = new schema({
    amount: Number,
    dateTime: {type: Date, default: Date.now()},
    products: [{
        id: String,
        title: String,
        quantity: Number,
        price: Number
    }],
    userId: {type: schema.Types.ObjectId, ref: 'userSchema'}
});

module.exports.productSchema = mongoose.model('productSchemaFlutter', product);
module.exports.orderSchema = mongoose.model('orderSchema', orderSchema);
module.exports.userSchema = mongoose.model('userSchema', userSchema);
